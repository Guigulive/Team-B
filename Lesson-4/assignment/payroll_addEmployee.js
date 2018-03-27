var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
    it("Add employee", function() {
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            return payrollInstance.addEmployee(accounts[1], 2);
        }).then(function() {
            return payrollInstance.employees.call(accounts[1]);
        }).then(function(employee) {
            assert.equal(employee[0], accounts[1], "The address is not correct");
            assert.equal(web3.fromWei(employee[1], "ether").toNumber(), 2, "The salary is not correct");
        });
    });
});
