var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(SafeMath);
  deployer.deploy(Ownable);
  deployer.deploy(SimpleStorage);
  deployer.link(SafeMath,Payroll);
  deployer.link(Ownable,Payroll);
  deployer.deploy(Payroll);
};
