// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ContractA {
    function foo() external pure returns (string memory) {
        return "Hello from ContractA";
    }
}

contract ContractB {
    function callContractA() external view returns (string memory) {
        address contractAAddress = 0x11bcD925D9c852a3eb40852A1C75E194e502D2b9; // Address of ContractA

        ContractA contractA = ContractA(contractAAddress);
        return contractA.foo();
    }
}
