// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Keccak256 {
    function hash(string memory text,uint _num, address _add) external pure returns (bytes32) {
        return keccak256(abi.encode(text, _num, _add));
        // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    }
    function hash23(string memory text) external pure returns (bytes memory) {
        bytes memory encodedData =  abi.encode(text);
        return encodedData; 
        }
}
        
