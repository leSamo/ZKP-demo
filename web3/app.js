const { Web3 } = require('web3');
const abi = require('./Token.json');
const proof = require('./proof.json');

var web3 = new Web3('http://localhost:8545');

const tokenContractAddress = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512';
const walletAddress = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'

let contract = new web3.eth.Contract(abi.abi, tokenContractAddress, {
    from: walletAddress
});

contract.methods
    .solve(proof.proof, proof.inputs)
    .send({ from: walletAddress })
    .on('receipt', receipt => {
        contract.methods
            .balanceOf(walletAddress)
            .call()
            .then(balance => console.log("Successfully submitted a solution, your new token balance is", balance))
            .catch(error => console.error(error))
    })
    .on('error', error => console.error(error))
