const ethers = require("ethers");
require("dotenv").config({ path: __dirname + "/./../.env" });
const API_URL = process.env.ALCHEMY_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const CONTRACT_ABI = require("../artifacts/contracts/SuperPikachu.sol/Pikachu.json");

let customHttpProvider = new ethers.providers.JsonRpcProvider("https://eth-goerli.alchemyapi.io/v2/" + API_URL);

async function gettx() {
  let contract = new ethers.Contract(
    CONTRACT_ADDRESS,
    CONTRACT_ABI.abi,
    customHttpProvider
  );

  const gettx = await contract.isWhitelistedAdmin("0xc79198cb232a77e425e02e4fd1c921dc154c968e");

  console.log("Tx is Successfull");
  // console.log(gettx());
  console.log(gettx.toString());

}

gettx();