var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

    const owner = accounts[0];
    const employId= accounts[1];
    const nowner = accounts[2];
    const salary = 8;

    it("测试添加的新员工 accounts[ 1 ] salary = 8", function() {
      return Payroll.deployed().then(function(instance) {
        PayrollInstance = instance;
        return PayrollInstance.addEmployee(employId,salary,{from: owner});
      }).then(function() {
        return PayrollInstance.employees.call(employId);
      }).then(function(employee) {
        assert.equal(employee[0], employId, "员工地址添加错误");
        assert.equal(employee[1],web3.toWei(salary,'ether'),"工资添加错误")
      });
    });
    

    it("测试是合约创建者添加新员工",function(){
      return Payroll.deployed().then(function(instance) {
        PayrollInstance = instance;
      try{  
        PayrollInstance.addEmployee(employId,salary,{from: nowner});
      }catch(e){
        return e.toString;
      }
    })
});


  it("添加相同的员工",function(){
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      try{  
        PayrollInstance.addEmployee(employId,salary,{from: owner});
        PayrollInstance.addEmployee(employId,salary,{from: owner});
      }catch(e){
        return e.toString();
      }
    })
  });
});

