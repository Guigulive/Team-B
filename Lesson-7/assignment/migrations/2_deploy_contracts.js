var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  console.log('delply 1');
  deployer.deploy(Ownable, {gas: 6721975});
  console.log('delply 2');  
  deployer.deploy(SafeMath);

  deployer.link(Ownable, Payroll);
  deployer.link(SafeMath, Payroll);
  deployer.deploy(Payroll);
};
