var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  const owner = accounts[0];
  const test_employee = accounts[1];

  it("...addEmployee with salary 2.", function() {
    return Payroll.deployed().then(instance => {
      payrollInstance = instance;
      return payrollInstance.addEmployee( test_employee, 2, {from: owner});
    }).then(() =>{
      return payrollInstance.Employees(test_employee);
    }).then((employee) => {
      // console.log(employee);
      assert.equal(employee[1], web3.toWei(2, 'ether'), "addEmployee is not success!");
    });
  });

});
