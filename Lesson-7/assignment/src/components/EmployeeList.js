import React, { Component } from 'react'
import { Table, Button, Modal, Form, InputNumber, Input, message, Popconfirm, Alert } from 'antd';

import EditableCell from './EditableCell';

const FormItem = Form.Item;

const columns = [{
  title: '地址',
  dataIndex: 'address',
  key: 'address',
}, {
  title: '薪水',
  dataIndex: 'salary',
  key: 'salary',
}, {
  title: '上次支付',
  dataIndex: 'lastPaidDay',
  key: 'lastPaidDay',
}, {
  title: '操作',
  dataIndex: '',
  key: 'action'
}];

class EmployeeList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      employees: [],
      showModal: false
    };

    columns[1].render = (text, record) => (
      <EditableCell
        value={text}
        onChange={ this.updateEmployee.bind(this, record.address) }
      />
    );

    columns[3].render = (text, record) => (
      <Popconfirm title="你确定删除吗?" onConfirm={() => this.removeEmployee(record.address)}>
        <a href="#">Delete</a>
      </Popconfirm>
    );
  }

  checkInfo() {
    const { payroll, account, web3 } = this.props;
    payroll.checkInfo.call({
      from: account
    }).then((result) => {
      const employeeCount = result[2].toNumber();

      if (employeeCount === 0) {
        // clear list if no employee
        this.setState({loading: false, employees: []});
        return;
      }

      this.loadEmployees(employeeCount);
    });
  }
  componentDidMount() {
    let {payroll} = this.props;
    this.checkInfo();
    
    this.newEmployeeEvent = payroll.NewEmployee(()=>this.checkInfo());
    this.updateEmployeeEvent = payroll.UpdateEmployee(()=>this.checkInfo());
    this.removeEmployeeEvent = payroll.RemoveEmployee(()=>this.checkInfo());
  }

  componentWillUnmount() {
    this.newEmployeeEvent.stopWatching();
    this.updateEmployeeEvent.stopWatching();
    this.removeEmployeeEvent.stopWatching();
  }
  async loadEmployees(employeeCount) {
    let {payroll, web3} = this.props;
    let employees = [];
    for(let i=0; i < employeeCount; i++) {
      let result = await payroll.checkEmployee.call(i);
      let [address, salary, lastPaidDay] = result;
      salary = web3.fromWei(salary).toNumber();
      lastPaidDay = lastPaidDay.toNumber();
      employees.push({address, salary, lastPaidDay, key: i});
    }
    this.setState({employees, loading:false});
  }

  addEmployee = () => {
    let {payroll, account} = this.props;
    payroll.addEmployee(this.state.address, this.state.salary, {from :account, gas: 500000})
    .then(()=> {
      this.setState({showModal: false});
    }, error => {
      alert('add employee error: '+ error.message)
    })
    
  }

  updateEmployee = (address, salary) => {
    let {payroll, account} = this.props;
    
    payroll.updateEmployee(address, salary, {from: account, gas: 500000})
    .then(()=> {
    }, error => {
      alert('updateEmployee error: '+ error.message);
    })
  }

  removeEmployee = (employeeId) => {
    let {payroll, account} = this.props;
    this.setState({loading:true})
    payroll.removeEmployee(employeeId, {gas: 500000, from: account})
      .then(()=> {
        this.setState({loading:false})
      }, error => {
        alert('删除错误:' + error.message);
        this.setState({loading:false})
      })

  }

  renderModal() {
      return (
      <Modal
          title="增加员工"
          visible={this.state.showModal}
          onOk={this.addEmployee}
          onCancel={() => this.setState({showModal: false})}
      >
        <Form>
          <FormItem label="地址">
            <Input
              onChange={ev => this.setState({address: ev.target.value})}
            />
          </FormItem>

          <FormItem label="薪水">
            <InputNumber
              min={1}
              onChange={salary => this.setState({salary})}
            />
          </FormItem>
        </Form>
      </Modal>
    );

  }

  render() {
    const { loading, employees } = this.state;
    return (
      <div>
        <Button
          type="primary"
          onClick={() => this.setState({showModal: true})}
        >
          增加员工
        </Button>

        {this.renderModal()}

        <Table
          loading={loading}
          dataSource={employees}
          columns={columns}
        />
      </div>
    );
  }
}

export default EmployeeList
