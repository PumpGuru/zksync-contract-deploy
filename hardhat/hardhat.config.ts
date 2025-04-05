import { HardhatUserConfig } from "hardhat/config";
import "@matterlabs/hardhat-zksync";

const config: HardhatUserConfig = {
  zksolc: {
    version: "latest",
    settings: {
      // Note: This must be true to call NonceHolder & ContractDeployer system contracts
      enableEraVMExtensions: true,
    },
  },
  defaultNetwork: "abstractTestnet",
  networks: {
    abstract: {
      url: "https://api.mainnet.abs.xyz",
      ethNetwork: "mainnet",
      zksync: true,
      verifyURL:
        "https://api-explorer-verify.mainnet.abs.xyz/contract_verification",
    },
    abstractTestnet: {
      url: "https://api.testnet.abs.xyz",
      ethNetwork: "sepolia",
      zksync: true,
      verifyURL:
        "https://api-explorer-verify.testnet.abs.xyz/contract_verification",
    },
  },
  solidity: {
    version: "0.8.24",
  },
};

export default config;
