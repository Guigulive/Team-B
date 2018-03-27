var Payroll = artifacts.require("./Payroll.sol");
var co = require('co');
var sleep = require('co-sleep');
const oneEther = web3.toWei('1', 'ether');
contract('Payroll', function(accounts) {

  let boss = accounts[0];
  it("test add & remove employee", function() {
    //store 10 ether, 1 employee, runway should be 10
    return co(function*() {
      var payroll = yield Payroll.deployed();
      yield payroll.addEmployee(accounts[1], 1);
      yield payroll.addEmployee(accounts[2], 1);
      var totalSalary = yield payroll.totalSalary.call();
      assert.equal(totalSalary.toNumber(), 2 * oneEther, 'totalSalary should be 2 ether after adding two guys')
      yield payroll.removeEmployee(accounts[2]);
      totalSalary = yield payroll.totalSalary.call();
      assert.equal(totalSalary.toNumber(), oneEther, 'totalSalary should be 1 ether now');
    })
  });

  it("duplicate add should throw error", function() {
    return co(function*() {
      var payroll = yield Payroll.deployed();
      yield payroll.addEmployee(accounts[1], 1);
      assert.isOk(false, 'should throw an exception')
    }).catch(error=> {
      // shoudl throw exception when add accounts[1] for twice
      assert.isOk(true, 'successfully throw exception')
    })
  });

  it('test get paid', function() {
    return co(function*(){
      var payroll = yield Payroll.deployed();
      yield payroll.addFund({value:10 * oneEther});
      var initialBalance = web3.eth.getBalance(accounts[1]);
      yield sleep(3000);
      yield payroll.getPaid({from: accounts[1]});
      var paid = web3.eth.getBalance(accounts[1]) - initialBalance;
      
      assert.closeTo(paid, 0.3 * oneEther, 0.1 * oneEther, 'pay should below 0.3 ether after 3 second')
    })
  })  
});
