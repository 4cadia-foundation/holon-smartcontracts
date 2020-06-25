const HDWalletProvider = require('truffle-hdwallet-provider');

require('dotenv').config();

module.exports = {
  networks: {
    development: {
        host: '127.0.0.1',
        port: 8545,
        network_id: '*',
        gas: 8000000,
        gasPrice: 10000000000
    },
    ropsten: {
        provider: () => new HDWalletProvider(process.env.MNEUNOMIC, "https://ropsten.infura.io/v3/" + process.env.INFURA_API_KEY),
        network_id: 3,
        gas: 3000000,
        gasPrice: 10000000000
    },
    kovan: {
        provider: () => new HDWalletProvider(process.env.MNEUNOMIC, "https://kovan.infura.io/v3/" + process.env.INFURA_API_KEY),
        network_id: 42,
        gas: 3000000,
        gasPrice: 10000000000
    },
    rinkeby: {
        provider: () => new HDWalletProvider(process.env.MNEUNOMIC, "https://rinkeby.infura.io/v3/" + process.env.INFURA_API_KEY),
        network_id: 4,
        gas: 7000000,
        gasPrice: 10000000000
    },
    main: {
        provider: () => new HDWalletProvider(process.env.MNEUNOMIC, "https://mainnet.infura.io/v3/" + process.env.INFURA_API_KEY),
        network_id: 1,
        gas: 3000000,
        gasPrice: 10000000000
    }
},
  compilers: {
    solc: {
      version: "0.5.11",
    }
  }
}
