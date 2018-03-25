// var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Ownable = artifacts.require("./Ownable.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.link(Ownable, Payroll);
  deployer.deploy(Payroll);
  // deployer.deploy(SimpleStorage);
};
