var Payroll = artifacts.require("./Payroll.sol");

/*
*可继续拓展用例测试非合约拥有者调用removeEmployee函数是否能成功
*/
contract('Payroll', function(accounts) {

  it("liteng test removeEmployee......", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(accounts[1], 100);
    }).then(function() {
      return payrollInstance.removeEmployee(accounts[1]);
    }).then(function() {
      return payrollInstance.employees(accounts[1]);
    }).then(function(employee) {
      console.log(employee);
      assert.equal(employee[1].toNumber(), 0, "removeEmployee fail");
    });
  });

});
