import React, { Component } from 'react'
import { Layout, Menu, Alert } from 'antd';

import Fund from './Fund';
import EmployeeList from './EmployeeList';

const { Content, Sider } = Layout;


class Employer extends Component {
    // constructor(props){
    //     super(props);

    //     this.state = {};
    // }

    // addFund = () => {
    //     const { employer, payroll, web3 } = this.props;
    //     payroll.addFund({
    //         from: employer,
    //         value: web3.toWei(this.fundInput.value),
    //         gas:3100000
    //     }).then((result) => {
    //         debugger
    //     })
    // }
    
    // addEmployee = () => {
    //     const { payroll, employer } = this.props;
    //     payroll.addEmployee(this.employeeInput.value, parseInt(this.salaryInput.value,0),{
    //         from: employer,
    //         gas: 3100000
    //     }).then((result) => {
    //         alert('success!')
    //     })
    // }

    // updateEmployee = () => {
    //     const { payroll, employer } = this.props;
    //     payroll.updateEmployee(this.employeeInput.value, parseInt(this.salaryInput.value,0), {
    //         from: employer,
    //         gas: 3100000
    //     }).then((result) => {
    //         debugger
    //         alert('success!')
    //     })
    // }

    // removeEmployee = () => {
    //     const { payroll, employer } = this.props;
    //     payroll.removeEmployee(this.employeeInput.value, {
    //         from: employer,
    //         gas: 3100000
    //     }).then((result) => {
    //         alert('success!')
    //     })
    // }



    // render(){

    //     return (
    //         <div>
    //             <h2>Employer</h2>
    //             <form className="pure-form pure-form-stacked">
    //                 <fieldset>
    //                     <legend>add Fund</legend>
    //                     <label>Fund</label>
    //                     <input
    //                       type="text"
    //                       placeholder="fund"
    //                       ref={(input) => { this.fundInput=input; }} />
    //                     <button type="button" className="pure-button" onClick={this.addFund}>add</button>
    //                 </fieldset>
    //             </form>

    //             <form className="pure-form pure-form-stacked">
    //                 <fieldset>
    //                     <legend>add/update employee</legend>
    //                     <label>employee id</label>
    //                     <input
    //                       type="text"
    //                       placeholder="employee"
    //                       ref={(input) => { this.employeeInput=input; }} />
    //                     <label>salary</label>
    //                     <input
    //                       type="text"
    //                       placeholder="salary"
    //                       ref={(input) => { this.salaryInput=input; }} />
    //                     <button type="button" className="pure-button" onClick={this.addEmployee}>addEmployee</button>
    //                     <button type="button" className="pure-button" onClick={this.updateEmployee}>updateEmployee</button>
    //                 </fieldset>
    //             </form>

    //             <form className="pure-form pure-form-stacked">
    //                 <fieldset>
    //                     <legend>remove employee</legend>
    //                     <label>employee id</label>
    //                     <input
    //                       type="text"
    //                       placeholder="employee"
    //                       ref={(input) => { this.employeeInput=input; }} />
    //                     <button type="button" className="pure-button" onClick={this.removeEmployee}>removeEmployee</button>
    //                 </fieldset>
    //             </form>
    //         </div>
    //     );
    // }

    // antd 
    constructor(props) {
        super(props);
    
        this.state = {
          mode: 'fund'
        };
      }
    
      componentDidMount() {
        const { account, payroll } = this.props;
        payroll.owner.call({
          from: account
        }).then((result) => {
          this.setState({
            owner: result
          });
        })
      }
    
      onSelectTab = ({key}) => {
        this.setState({
          mode: key
        });
      }
    
      renderContent = () => {
        const { account, payroll, web3 } = this.props;
        const { mode, owner } = this.state;
    
        if (owner !== account) {
          return <Alert message="你没有权限" type="error" showIcon />;
        }
    
        switch(mode) {
          case 'fund':
            return <Fund account={account} payroll={payroll} web3={web3} />
          case 'employees':
            return <EmployeeList account={account} payroll={payroll} web3={web3} />
        }
      }
    
      render() {
        return (
          <Layout style={{ padding: '24px 0', background: '#fff'}}>
            <Sider width={200} style={{ background: '#fff' }}>
              <Menu
                mode="inline"
                defaultSelectedKeys={['fund']}
                style={{ height: '100%' }}
                onSelect={this.onSelectTab}
              >
                <Menu.Item key="fund">合约信息</Menu.Item>
                <Menu.Item key="employees">雇员信息</Menu.Item>
              </Menu>
            </Sider>
            <Content style={{ padding: '0 24px', minHeight: 280 }}>
              {this.renderContent()}
            </Content>
          </Layout>
        );
      }

}

export default Employer