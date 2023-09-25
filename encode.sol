// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EncodeExample {
    function encodeExample(uint256 value, string memory text) public pure returns (bytes memory) {
        bytes memory encodedData = abi.encode(value, text);
        return encodedData;
    }
}
