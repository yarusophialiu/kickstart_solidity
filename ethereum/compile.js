const path = require('path')
const solc = require('solc')
const fs = require('fs-extra')


const buildPath = path.resolve(__dirname, 'build')
// delete build foder
fs.removeSync(buildPath)

// read Campaign.sol from contracts folder
const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol')
const source = fs.readFileSync(campaignPath, 'utf8')
const output = solc.compile(source, 1).contracts


fs.ensureDirSync(buildPath);

for (let contract in output) {
    fs.outputJSONSync(
        path.resolve(buildPath, contract.replace(':', '') + '.json'),
        output[contract]
    )
}