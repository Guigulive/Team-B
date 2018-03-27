var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

    const owner = accounts[0];
    const employId= accounts[1];
    const nowner = accounts[2];
    const salary = 8;

    it("测试删除员工", function() {
      return Payroll.deployed().then(function(instance) {
        PayrollInstance = instance;
        return PayrollInstance.addEmployee(employId,salary,{from: accounts[0]});
      }).then(function(){
        PayrollInstance.removeEmployee(employId,{from: accounts[0]});
        return PayrollInstance.employees.call(employeeId );}
      ).then(function(employee){
        assert.equal( employee[ 0 ], '0x0000000000000000000000000000000000000000', "删除员工不成功" );
      })
  });

    it("测试是合约创建者删除新员工", function() {
      return Payroll.deployed().then(function(instance) {
        PayrollInstance = instance;
        return PayrollInstance.addEmployee(employId,salary,{from: owner});
      }).then(function(){
        try{
          PayrollInstance.removeEmployee(employId,{from: nowner});
        }catch(e){
          return e.toString();
        }
      })
    });
  
  
    it("测试删除不存在的新员工", function() {
      return Payroll.deployed().then(function(instance) {
        PayrollInstance = instance;
      }).then(function(){
        try{
          PayrollInstance.removeEmployee(employId,{from: owner});
        }catch(e){
          return e.toString();
        }
      }
      )
    });

});

