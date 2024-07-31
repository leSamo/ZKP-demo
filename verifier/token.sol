pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "./verifier.sol";

contract Token is ERC20{
    Verifier verifierContract;

    uint256[] private numbers;

    function addressToUint256(address a) internal pure returns (uint256) {
        return uint256(uint160(a));
    }

    constructor(address _verifierContract, uint256[] memory _numbers) ERC20("ZeroKnowledgeToken", "ZKTK") {
        verifierContract = Verifier(_verifierContract);

        numbers = _numbers;
    }

    function solve(Verifier.Proof memory proof, uint[3] memory input) public returns (bool) {
        require(addressToUint256(msg.sender) == input[1], "Sender address does not match the proof parameter.");

        if (verifierContract.verifyTx(proof, input)) {
            _mint(msg.sender, 1e18);

            return true;
        }
        else {
            return false;
        }
    }
}