import { Deployer } from "@matterlabs/hardhat-zksync";
import { Wallet } from "zksync-ethers";
import { vars } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { randomBytes } from "ethers";
import { TransactionReceipt } from "zksync-ethers/build/types";
import { mnemonic, privateKey } from "../secrets.json";

/**
 * An example of using the hardhat-zksync plugin to deploy smart contracts.
 *  1. Deploys the MyContractFactory contract.
 *    - Since the factory can also deploy the MyContract contract, it also requires the bytecode of the MyContract contract in factoryDeps.
 *    - However, the zksolc compiler detects it automatically, and populates it in the factoryDeps field of the factory artifact.
 *       - See the /artifacts-zk/contracts/MyContractFactory.sol/MyContractFactory.json - factoryDeps field.
 *    - The Deployer from @matterlabs/hardhat-zksync reads this and includes the factoryDeps in the EIP-712 deployment transaction.
 * 
 *  2. Using the factory, deploy an new instance of MyContract via the 4 different methods.
 */

export default async function (hre: HardhatRuntimeEnvironment) {
  console.log(`Running deploy script... 👨‍🍳`);

  const wallet = new Wallet(privateKey);

  // Create deployer from hardhat-zksync and load the artifact of the contract we want to deploy.
  const deployer = new Deployer(hre, wallet);

  // Load the artifact. Remember, for the factory, this artifact includes the factoryDeps containing the reference to the MyContract bytecode.
  const paymasterContract = await deployer.loadArtifact("Paymaster");

  const deployedFactoryContract = await deployer.deploy(paymasterContract);

  console.log(
    `Deployed ${paymasterContract.contractName} at ${await deployedFactoryContract.getAddress()} 🚀     
    `
  );
}

