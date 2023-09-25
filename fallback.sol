// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;
contract Fallback {
    event Log(string fuc,uint gas);
    fallback() external payable {
        emit Log("Fallback", gasleft());
    }
}
contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}