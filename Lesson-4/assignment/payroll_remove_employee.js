var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
    const owner = accounts[0];
    const test_employee = accounts[1]
    const salary = 2

  it("Add an employee then remove him.", function() {
    var payroll;
    return Payroll.deployed().then(instance => {
      payroll = instance;
      return payroll.addEmployee(test_employee, salary, {from: owner});
    }).then(() => {
      return payroll.removeEmployee(test_employee, {from: owner});
    }).then(() => {
      return payroll.employees(test_employee);
    }).then(employee_info => {
      assert.equal(employee_info[0], 0, "Employee id not equal to 0.");
    });
  });
});
