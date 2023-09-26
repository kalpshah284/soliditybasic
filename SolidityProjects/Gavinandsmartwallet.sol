// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SmartWallet {
    address public owner;
    uint public Amount;
    constructor(address _owner){
        owner = _owner;
    }
    mapping (address => bool) public X;
    mapping (address => uint) public bal;
    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
    }
    modifier Access(){
        require(X[msg.sender] || owner == msg.sender, "Access");
         _;
    }
     modifier revokAccess(){
        require(!X[msg.sender], "Revoke Access");
         _;
    }

    //this function allows adding funds to wallet
    function addFunds(uint amount) public Access  {
      Amount += amount;
      require(Amount <= 10000,"amount should not exceed 10000");
    }

    //this function allows spending an amount to the account that has been granted access by Gavin
    function spendFunds(uint amount) public  Access {        
        require(Amount >= amount," balance cannot be negative");
        Amount -= amount;
    }

    //this function grants access to an account and can only be accessed by Gavin
    function addAccess(address x) public onlyOwner {
        X[x] = true;
    }

    //this function revokes access to an account and can only be accessed by Gavin
    function revokeAccess(address x) public onlyOwner  {
       X[x] = false;
    }

    //this function returns the current balance of the wallet
    function viewBalance() public Access returns(uint) {
        
        uint a =  bal[msg.sender] = Amount;
        return a;
    }

}