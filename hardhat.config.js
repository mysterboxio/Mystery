require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
// require("@nomiclabs/hardhat-solpp");
require("hardhat-gas-reporter");
require("solidity-coverage");
const dotenv = require('dotenv');
dotenv.config();

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 const PRIVATE_KEY = process.env.PRIVATE_KEY;

 const BSC_URL = process.env.BSC_URL;
 const BSC_SCAN_APIKEY = process.env.BSC_SCAN_APIKEY;

module.exports = {
  gasReporter: {
    enabled: true,
    currency: 'CHF',
    gasPrice: 21
  },
  networks: {
    hardhat: {
      mining: {
        auto: false,
        interval: 5000
      },
      blockGasLimit: 13000000,
      gasPrice: 20
    },
    bsc: {
      url: BSC_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    
    apiKey: BSC_SCAN_APIKEY
  },
  // slopp: {
  //   defs: {},
  //   cwd: './contracts',
  //   name: "hardhat-solpp",
  //   collapseEmptyLines: false,
  //   noPreprocessor: false,
  //   noFlatten: false,
  //   tolerant: false,
  // },
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    ]
  }  
};
