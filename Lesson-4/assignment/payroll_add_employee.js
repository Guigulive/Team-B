var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
    const owner = accounts[0];
    const test_employee = accounts[1]
    const salary = 2

  it("Add employee with salary 2.", function() {
      var payroll;
      return Payroll.deployed().then(instance => {
        payroll = instance;
        return payroll.addEmployee(test_employee, salary, {from: owner});
    }).then(() => {
      return payroll.employees(test_employee);
    }).then(employee_info => {
      assert.equal(employee_info[1].toString(), web3.toWei(2), "Added employee salary wrong!");
    });
  });
});
