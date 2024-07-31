pragma solidity ^0.8.0;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "./verifier.sol";

contract Token is ERC20 {
    Verifier verifierContract;

    uint256[] private numbers;

    constructor(address _verifierContract, uint256[] memory _numbers) ERC20("ZeroKnowledgeToken", "ZKTK") {
        verifierContract = Verifier(_verifierContract);

        numbers = _numbers;
    }

    function addressToUint256(address a) internal pure returns (uint256) {
        return uint256(uint160(a));
    }

    function isNumberListed(uint element) public view returns (bool) {
        for (uint i = 0; i < numbers.length; i++) {
            if (numbers[i] == element) {
                return true;
            }
        }
        return false;
    }

    function solve(Verifier.Proof memory proof, uint[3] memory input) public {
        uint n = input[0];
        uint addr = input[1];

        require(isNumberListed(n));
        require(addressToUint256(msg.sender) == addr, "Sender address does not match the proof parameter.");
        require(verifierContract.verifyTx(proof, input));

        // Here should be some code which removes the solved n from
        // the numbers array to prevent getting reward for the same numbers

        _mint(msg.sender, 1e18);
    }

    function getAvailableNumbers() public view returns (uint256[] memory) {
        return numbers;
    }
}
