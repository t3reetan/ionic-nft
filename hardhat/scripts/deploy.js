const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" }); // use of "path": specifying a custom path containing your environment variables
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {
  // Address of the whitelist contract that you deployed in the previous module
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;

  // URL from where we can extract the metadata for a Ionic NFT
  const metadataURL = METADATA_URL;

  /*
   * A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
   * so "ionicNFTsContract" here is a factory for instances of our IonicNFT contract.
   * Think of it like a class, creating object instances. Car class creates car instances.
   */
  const ionicNFTContract = await ethers.getContractFactory("IonicNFT");

  // deploy the contract
  const deployedIonicNFTContract = await ionicNFTContract.deploy(
    metadataURL,
    whitelistContract
  );

  // print the address of the deployed contract
  console.log("Ionic NFT Contract Address:", deployedIonicNFTContract.address);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
