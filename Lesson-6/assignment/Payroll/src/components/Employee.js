import React, { Component } from 'react'
import { Card, Col, Row, Layout, Alert, message, Button } from 'antd';

import Common from './Common';

class Employee extends Component {
    // constructor(props){
    //     super(props);

    //     this.state = {};
    // }

    // componentDidMount() {
    //     this.checkEmployee();
    // }

    // checkEmployee = () => {
    //     const { payroll, employee, web3} = this.props;
    //     payroll.employees.call(employee, {
    //         from: employee,
    //         gas: 200000
    //     }).then((result) => {
    //         debugger
    //         console.log(result);
    //         this.setState({
    //             salary: web3.toWei(result[1].toNumber()),
    //             lastPaidDay: new Date(result[2].toNumber() * 1000)
    //         })
    //     })
    // }

    // getPaid = () => {
    //     const { payroll, employee } = this.props;
    //     payroll.getPaid({
    //         from: employee,
    //         gas: 100000
    //     }).then((result) => {
    //         alert('You have been paid!')
    //     })
    // }



    // render(){

    //     const { salary, lastPaidDay } = this.state;
    //     const { employee } = this.props;

    //     return (
    //         <div>
    //             <h2>员工: {employee}</h2>{
    //                 (!salary || salary === 0)?
    //                 <p>你现在还不是雇员</p>:(
    //                     <div>
    //                         <p>薪水:{salary}</p>
    //                         <p>最后支付时间:{lastPaidDay.toString()}</p>
    //                         <button type="button" className="pure-button" onClick={this.getPaid}>获取薪水</button>
    //                     </div>
    //                 )
    //             }
    //         </div>
    //     );
    // }

    // antd 
    constructor(props) {
        super(props);
        this.state = {};
      }
    
      componentDidMount() {
        const { payroll } = this.props;
        const updateInfo = (error, result) => {
          if(!error){
            this.checkEmployee()
          }else{
            console.log(error)
          }
        }

        this.getPaidEvent = payroll.GetPaid(updateInfo);
        this.checkEmployee();
      }

      componentWillUnmount() {
        this.getPaidEvent.stopWatching();
      }
    
      checkEmployee = () => {
        const { payroll, account, web3 } = this.props;
        payroll.employees.call(account, {
            from: account,
            gas: 300000
        }).then((result) => {
            console.log(result);
            this.setState({
                salary: web3.fromWei(result[1].toNumber()),
                lastPaidDate: (new Date(result[2].toNumber() * 1000)).toString(),
            });
            web3.eth.getBalance(account, (error, result) =>{
              if(!error){
                  this.setState({
                    balance: web3.fromWei(result.toNumber(), 'ether'),
                  });
              }
            })
        })
      }
    
      getPaid = () => {
        const { payroll, account } = this.props;
        payroll.getPaid({
            from: account,
            gas: 300000
        }).then((result) => {
            console.log(result);
        }).catch((error) => {
            console.log(error);
            message.info('getPaid fail!');
        })
      }
    
      renderContent() {
        const { salary, lastPaidDate, balance } = this.state;
    
        if (!salary || salary === '0') {
          return   <Alert message="你不是员工" type="error" showIcon />;
        }
    
        return (
          <div>
            <Row gutter={16}>
              <Col span={8}>
                <Card title="薪水">{salary} Ether</Card>
              </Col>
              <Col span={8}>
                <Card title="上次支付">{lastPaidDate}</Card>
              </Col>
              <Col span={8}>
                <Card title="帐号金额">{balance} Ether</Card>
              </Col>
            </Row>
    
            <Button
              type="primary"
              icon="bank"
              onClick={this.getPaid}
            >
              获得酬劳
            </Button>
          </div>
        );
      }
    
      render() {
        const { account, payroll, web3 } = this.props;
    
        return (
          <Layout style={{ padding: '0 24px', background: '#fff' }}>
            <Common account={account} payroll={payroll} web3={web3} />
            <h2>个人信息</h2>
            {this.renderContent()}
          </Layout >
        );
      }

}

export default Employee