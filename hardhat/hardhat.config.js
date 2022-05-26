require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });

const ALCHEMY_API_KEY_URL = process.env.ALCHEMY_API_KEY_URL;

const ETH_PRIVATE_KEY = process.env.ETH_PRIVATE_KEY;

module.exports = {
  solidity: "0.8.4", // solidity version
  networks: {
    rinkeby: {
      url: ALCHEMY_API_KEY_URL,
      accounts: [ETH_PRIVATE_KEY],
    },
  },
};
