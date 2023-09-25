// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract MultiSigWallet {
    event deposit(address indexed  sender, uint amount);
    event submit(uint indexed Txid);
    event approved(address indexed owner, uint amount);
    event revoke(address indexed owner, uint amount);
    event execute(uint indexed Txid);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }
    uint i;
    address[] public owners;
    mapping (address => bool) public isOwner;
    uint public required;
    mapping(uint => mapping(address => bool)) public approve;

    Transaction[] public transactions;

    modifier onlyOwner(){
        require(isOwner[msg.sender],"not owner");
        _;
    }
    modifier txExists(uint _txid){
        require(_txid < transactions.length,"tx does not exist" );
        _;
    }
    modifier notApprov(uint _txid){
        require(!approve[_txid][msg.sender],"tx already approv" );
        _;
    }
    modifier notexecuted(uint _txid){
        require(!transactions[_txid].executed,"tx already exetcuted");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owner is require");
        require(_required > 0 && _required <= _owners.length, "invalid require number of owner");
        for (uint o; o < _owners.length; o++)
        {
            address owner = _owners[o];
            require(owner != address(0),"invalid owner");
            require(!isOwner [owner], "owner is not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
         
        required = _required;
    }

    receive() external payable {
        emit deposit(msg.sender, msg.value);
    }


    function Submit(address _to, uint _value,bytes calldata _data) 
    external
    onlyOwner
    {
            transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));
        emit submit(transactions.length - 1);

    }

    function Approve(uint _txid)
    external 
    onlyOwner
    txExists(_txid)
    notApprov(_txid)
    notexecuted(_txid) {
        
        approve[_txid][msg.sender] = true;
        emit approved(msg.sender, _txid);
    }

    function _getapprovalcount(uint _txid) private view returns (uint count) {
        for (uint o; i < owners.length; o++) 
        { 
           if (approve[_txid][owners[o]]){
               count++; 
           }
        }
    }
    function Execute (uint _txid) external txExists(_txid) notexecuted(_txid) {
        require(_getapprovalcount(_txid) >= required,"appval < required");
        Transaction storage transaction = transactions[_txid];
        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "tx failed");
        emit execute(_txid);
    }

    function Revoke(uint _txid)
    external 
    onlyOwner
    txExists(_txid)
    notexecuted(_txid){
        require(approve[_txid][msg.sender],"tx not approv" );
        approve[_txid][msg.sender] = false;
        emit revoke(msg.sender, _txid);
        
    }
     function callMe(uint j) public {
        i += j;
    }

    function getData() public pure returns (bytes memory) {
        return abi.encodeWithSignature("callMe(uint256)", 123);
    }
}

