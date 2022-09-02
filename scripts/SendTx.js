const {BigNumber, ethers} = require("ethers");
require("dotenv").config({ path: __dirname + "/./../.env" });
const API_URL = process.env.ALCHEMY_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const CONTRACT_ABI = require("../artifacts/contracts/SuperPikachu.sol/Pikachu.json");

let customHttpProvider = new ethers.providers.JsonRpcProvider("https://eth-goerli.alchemyapi.io/v2/" + API_URL);

async function main(_address) {
  let wallet = new ethers.Wallet(PRIVATE_KEY, customHttpProvider);

  let signer = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI.abi, wallet);

  const mintNft = await signer.whitelistUser(_address);

  // await mintNft.wait();
  console.log("NFT Minted");
  console.log(mintNft);
}

 main("0xc79198cb232a77e425e02e4fd1c921dc154c968e",{
  gasPrice: 250000
 }
);