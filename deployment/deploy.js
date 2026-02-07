import hre from "hardhat";

async function main() {
  const EducationCrowdfunding = await hre.ethers.getContractFactory(
    "EducationCrowdfunding"
  );

  const contract = await EducationCrowdfunding.deploy();

  await contract.waitForDeployment();

  console.log("EducationCrowdfunding deployed to:", await contract.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
