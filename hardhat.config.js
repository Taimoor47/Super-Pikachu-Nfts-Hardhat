/**
* @type import('hardhat/config').HardhatUserConfig
*/

require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const { ALCHEMY_KEY, PRIVATE_KEY } = process.env;

// if (!ALCHEMY_KEY) {
//   throw new Error("ALCHEMY_KEY env var is not set");
// }

// if (!PRIVATE_KEY) {
//   throw new Error("PRIVATE_KEY env var is not set");
// }

module.exports = {
   solidity: "0.8.4",
   networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_KEY}`,
      accounts: [`${PRIVATE_KEY}`,],

    },

   
  },
}