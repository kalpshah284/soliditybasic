
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Test {
  function encode() external pure returns(bytes memory) {
    bytes memory x = abi.encodeWithSignature("withdraw(address)",0xaaC5322e456d45E7b6c452038836C5631C2AeBc0);
    return x;

}
}
