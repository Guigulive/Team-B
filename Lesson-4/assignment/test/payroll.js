var Payroll = artifacts.require("./Payroll.sol");
 
contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee = accounts[1];
  const employee2 = accounts[2];
  
 
  it("Test addEmployee()", function () {
    var payroll;
    return Payroll.deployed().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, 1, { from: owner });
    }).then(() => {
      return payroll.employees(employee);
    }).then(employeeInfo => {
      assert.equal(employeeInfo[1].toNumber(), web3.toWei(1, 'ether'), "sorry,addEmployee failed");
    });
  });

  it("Test removeEmployee()", function () {
    var payroll;
    return Payroll.deployed.call(owner, {from: owner, value: web3.toWei(100, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee2, 1, { from: owner });
    }).then(() => {
      return payroll.removeEmployee(employee2);
    }).then(() => {
      return payroll.employees(employee2);
    }).then(employeeInfo => {
      assert.equal(employeeInfo[1].toNumber(), 0, "sorry,removeEmployee failed");
    });
  });
});

 