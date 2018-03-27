var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("Testing addEmployee, total salary.", function() {
    return Payroll.new().then(function(instance) {
      p = instance;

      p.addEmployee(accounts[1],1, {from: accounts[0]});

      p.addEmployee(accounts[2],2, {from: accounts[0]});

      p.addEmployee(accounts[3],1, {from: accounts[0]});

    }).then(function() {
      return p.totalSalary.call();
    }).then(function(total) {
      assert.equal(total, 4000000000000000000, "Total salary is not 4 ether.");
    });
  });

  it("Testing addEmployee, salary and lastPayDay.", function() {
    return Payroll.new().then(function(instance) {
      p = instance;

      p.addEmployee(accounts[1],1, {from: accounts[0]});

    }).then(function() {
      return p.employees.call(accounts[1]);
    }).then(function(employee) {
      var timestamp = Date.parse(new Date())/1000;

      //console.log(employee,timestamp);
      
      assert.equal(employee[1], 1000000000000000000, "New employee salary is not 1 ether.");
      
      assert(employee[2] <= timestamp, "New employee lastPayDay hasn't began.");
    });
  });

  it("Testing addEmployee by non owner.", function() {
    return Payroll.new().then(function(instance) {
      p = instance;
      return p.addEmployee(accounts[1],1, {from: accounts[1]});
    }).then(assert.fail).catch(function(error) {
      assert(true, "Non owner call addEmployee failed!");
    });
  });

  it("Testing addEmployee then removeEmployee, total salary.", function() {
    return Payroll.new().then(function(instance) {
      p = instance;

      p.addEmployee(accounts[1],1, {from: accounts[0]});

      p.addEmployee(accounts[2],2, {from: accounts[0]});

      p.addEmployee(accounts[3],1, {from: accounts[0]});

      p.removeEmployee(accounts[3], {from: accounts[0]});

    }).then(function() {
      return p.totalSalary.call();
    }).then(function(total) {
      assert.equal(total, 3000000000000000000, "Total salary is not 3 ether.");
    });
  });  

});
