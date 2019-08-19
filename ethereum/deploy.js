const HDWalletProvider = require('truffle-hdwallet-provider')
const Web3 = require('web3')
const { interface, bytecode } = require('./compile')
const compiledFactory = require('./build/CampaignFactory.json')

const provider = new HDWalletProvider(
    'nurse item escape exact silk sure together oven erode way apology jelly',
    'https://rinkeby.infura.io/v3/24890fd5002e429a857d268694ca199a'
)

const web3 = new Web3(provider)

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    console.log('attemping', accounts[0])

    const result = await new web3.eth.Contract(
        JSON.parse(compiledFactory.interface)
    )
        .deploy({data: '0x' + compiledFactory.bytecode }) // add 0x bytecode
        .send({from: accounts[0]}); // remove 'gas'

    console.log('addresss', result.options.address)
}

deploy()