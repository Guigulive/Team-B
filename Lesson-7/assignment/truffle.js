var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = 'omit wealth film sunny faculty priority endless panel energy verb tree deer';

module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/8Crf9sXudSYJFZjsJz97");
      } ,
      gas: 4712388,
      network_id: 3
    }
    
  }
};
