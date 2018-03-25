var Payroll = artifacts.require("./Payroll.sol");
 
 contract('Payroll', function (accounts) {
   const owner = accounts[0]
   const employee = accounts[1]
   const guest = accounts[5]
   const salray = 1;
   const runway = 2;
   const payDuration = 10 + 1;
   const fund = runway * salray;
 
   it("Test getPaid()", function () {
     var payroll;
     return Payroll.deployed.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
       payroll = instance;
       return payroll.addEmployee(employee, salray, { from: owner });
     }).then(() => {
       return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
     }).then(() => {
       return payroll.addFund({from: owner, value: web3.toWei(fund, 'ether')});
     }).then(() => {
       return payroll.calcRunway();
     }).then(runwayRet => {
       assert.equal(runwayRet, runway, "Try addFund() fail, runway is not right");
       return payroll.getPaid({from: employee})
     }).then((getPaidRet) => {
     }).then(() => {
       return payroll.calcRunway();
     }).then(runwayRet => {
       assert.equal(runwayRet, runway - 1, "The runway is not correct");
     });
   });

});