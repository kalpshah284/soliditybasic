// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
contract EtherWallet {
    address payable public owner;
    constructor() {
        owner= payable(msg.sender);
    }
    receive() payable external {}
    function withdraw(uint _amount) external {
        require(msg.sender==owner, "caller is not owner");
        owner.transfer(_amount);

    }
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}