# ZoKrates demo -- Rewarding integer factorization
This is a demo showcasing ZoKrates library as a part of introduction to zero-knowledge proofs (`see slides.pdf`).

## Prerequisites
1. Make sure you have [ZoKrates](https://zokrates.github.io/gettingstarted.html) installed
2. Make sure you have [Node.js](https://nodejs.org) installed
3. Make sure you have [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
4. Run `forge install` to fetch dependencies

## Verifier side
Perform these steps inside the `verifier/` folder.

### Perform trusted setup and export contract
1. Compile program into aritmetic circuit with `zokrates compile -i program.zok`
2. Generate proving and verification keys with `zokrates setup`
3. Generate smart contract with `zokrates export-verifier`
4. Copy `proving.key` into the `prover/` folder

### Deploying contracts
There is an [ERC20](https://ethereum.org/en/developers/docs/standards/tokens/erc-20/) contract prepared inside `token.sol`. This contract hooks onto the verifier contract and uses it to verify the proof. If the proof is valid, tokens are minted to the sender address.

1. Start local network with `anvil` inside a second terminal window
2. Deploy verifier contract with `forge create --rpc-url 127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 verifier/verifier.sol:Verifier`
3. Deploy token contract with `forge create --rpc-url 127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 verifier/token.sol:Token --constructor-args <verifier contract address from the previous command> [55,77,143]` command

## Prover side
Perform these steps inside the `prover/` folder. You should have `proving.key` inside your `prover/` folder from the previous steps.

### Generating a proof
1. Compile program into aritmetic circuit with `zokrates compile -i program.zok`
2. Generate a witness with `zokrates compute-witness -a <p> <q> <n> <address>` where `p * q == n` and `address` corresponds to the address from which you will interact with the contract
3. Generate the proof with `zokrates generate-proof`

### Testing contracts
1. Run `npm install` inside `web3/` folder to install the `web3` package
2. Copy `Token.json` ABI from `out/token.sol/` into the `web3/` folder
3. Copy `proof.json` into the `web3/` folder
4. Replace `tokenContractAddress` inside `app.js`
5. Navigate to  the `web3/` folder and run `node app.js`
