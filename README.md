# Super-Pikachu-Nfts-Hardhat

## Tutorial
Pull/Download Repo.

#### Run following command

```
npm Install

```
Nfts Collection link minted by this Smart Contract.

https://testnets.opensea.io/collection/super-pikachu-cm3kjx3q3q

Here is deployed smart contract address check on goerli etherscan.

```
 0x41f5c114cb46dc3babd48c7c499d6b2a87e8e657

```

.evn structure

```
PRIVATE_KEY=
ALCHEMY_KEY=
CONTRACT_ADDRESS=

```

hardhat config.

```
/**
* @type import('hardhat/config').HardhatUserConfig
*/

require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const { ALCHEMY_KEY, PRIVATE_KEY } = process.env;

module.exports = {
   solidity: "0.8.4",
   networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_KEY}`,
      accounts: [`${PRIVATE_KEY}`,],

    },

   
  },
}

```



