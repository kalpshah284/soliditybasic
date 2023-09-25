// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract LendingBorrowingPrograme {
    uint public poolamount;
    uint public Fixrate;
    uint public minamountInpool;

    struct Lender {
        address Wallet;
        uint amountlended; 
    }
    struct Borrower {
        address wallet;
        uint amountborrow;
    }
    mapping (uint => Lender) public lenders;
    mapping (uint => Borrower) public borrowers;
    uint public numLenders;
    uint public numBorrowers;
    constructor(uint _fixrate)  {
      
        Fixrate = _fixrate;
    }
    function addLender(address _wallet, uint _amount) external payable {
        Lender storage newLender = lenders[numLenders];
        newLender.Wallet = _wallet;
        newLender.amountlended = _amount;
        numLenders++;
    }
    function addBorrower(address _wallet, uint _amount) external {
        Borrower storage newBorrower = borrowers[numBorrowers];
        newBorrower.wallet = _wallet;
        newBorrower.amountborrow = _amount;
        numBorrowers++;
    }
    
    

    
}