// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Piggybank {
    address public owner = msg.sender;
    event deposit(uint amt);
    event Withdraw(uint amt);
    receive () external payable {
        emit deposit(msg.value);
    }
   
    
    function withdraw() external {
        require(msg.sender == owner, "not owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable (msg.sender));
    }
    
}