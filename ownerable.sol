// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract Ownable {
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    modifier Onlyowner() {
        require(owner == msg.sender,"not owner");
        _;
    }
    function setowner(address _newaddress) external Onlyowner {
        require(_newaddress != address(0), "address is invalid");
        owner = _newaddress;
    }
    function Onlyownercancallthisfuc() external Onlyowner{

    }
    function anyonecancallthisfuc() external {

    }
}