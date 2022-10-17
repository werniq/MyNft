const hre = require("hardhat");
const { ethers } = require("hardhat");


async function main() {

  const contract = await ethers.getContractFactory("Nft");
  const nft = await contract.deploy();

  await nft.deployed();

  console.log("Nft deployed to:", nft.address);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

