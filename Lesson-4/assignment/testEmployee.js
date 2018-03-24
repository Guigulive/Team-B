var Payroll = artifacts.require("./Payroll.sol");
contract('Payroll', function(accounts) {

  it("liteng test addEmployee......", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(accounts[1], 100);
    }).then(function() {
      return payrollInstance.employees(accounts[1]);
    }).then(function(employee) {
      console.log(employee);
      assert.equal(employee[1].toNumber(), web3.toWei(100, 'ether'), "addEmployee fail");
    });
  });

});
