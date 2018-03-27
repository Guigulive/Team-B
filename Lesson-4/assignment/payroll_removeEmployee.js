var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
    it("Remove employee", function() {
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
        }).then(function() {
            return payrollInstance.employees.call(accounts[1]);
        }).then(function(employee) {
            assert.equal(employee[0], "0x0", "The employee is not removed");
        });
    });
});
