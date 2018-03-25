var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {

      const owner = accounts[0]
      const employee = accounts[1]
      const salary = 1;
    
      it("Test call addEmployee() and removeEmployee by owner", function () {
       var payroll;
       return Payroll.deployed().then(instance => {
         payroll = instance;
          return payroll.addEmployee(employee, salary, { from: owner });
       }).then(() => {
          return payroll.removeEmployee(employee);
       }).then(() => {
          return payroll.Employees(employee);
        }).then(employeeInfo => {
          assert.equal(employeeInfo[0], 0, "Fail to call addEmployee() and removeEmployee()");
        });
     });


     it("Test remove a non-existent employee", function () {
        var payroll;
        return Payroll.deployed().then(function (instance) {
            payroll = instance;
            return payroll.removeEmployee(employee);
        }).then(() => {
            assert(false, "Should not be successful");
        }).catch(error => {
            assert.include(error.toString(), "invalid opcode", "Can not remove a non-existent employee");
        });
     });


})