// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;  
contract TimeLock { 
    error NotOwnerError(); 
    error AlreadyQueuedError(bytes32 txId);
    error TimestampNotInRange(uint blockTimestamp, uint timestamp);
    error NotQueuedError(bytes32 txid);
    error TimestampNotPassError(uint blockTimestamp,uint timestamp);
    error TimestampExpireError(uint blockTimestamp,uint expireAt );
    error TxFailedError();

    event Queue(
        bytes32 indexed txId, 
        address indexed target,
        uint value,
        string  fuc, 
        bytes data,
        uint _timestamp
        );
    event Execute (
        bytes32 indexed txId, 
        address indexed target,
        uint value,
        string  fuc, 
        bytes data,
        uint _timestamp
        );  
    event Cancel(bytes32 indexed _txId);    
    uint public constant MIN_DELAY = 10;
    uint public constant MAX_DELAY = 1000;
    uint public constant  GRACE_PERIOD = 1000;
    
    address public owner;
    mapping(bytes32 => bool) public queued;  
    constructor() {
        owner = msg.sender;
    }
    receive() external payable{} 
    modifier OnlyOwner() {
        if(msg.sender != owner){
            revert NotOwnerError();
            _;
        }
    }
    function getTxId(
        address _target,
        uint _value,
        string calldata _fuc,
        bytes calldata _data,
        uint _timestamp) public pure returns(bytes32 txId ) {
            return keccak256(abi.encode(_target,_value,_fuc,_data,_timestamp));
    }
    function queue(
        address _target,
        uint _value,
        string calldata _fuc,
        bytes calldata _data,
        uint _timestamp
    ) external OnlyOwner{
        //create txid
        bytes32 txId = getTxId(_target, _value, _fuc, _data, _timestamp);
        //check txid unique
        if(queued[txId]){
            revert AlreadyQueuedError(txId);
        }
        //check timestame
        if(_timestamp < block.timestamp + MIN_DELAY ||
           _timestamp < block.timestamp + MAX_DELAY){
               revert TimestampNotInRange(block.timestamp,_timestamp);
           }
        //queque tx
        queued[txId] = true;
        emit Queue(txId, _target, _value, _fuc, _data, _timestamp);
    }
    function execute(
        address _target,
        uint _value,
        string calldata _fuc,
        bytes calldata _data,
        uint _timestamp
    ) external payable OnlyOwner returns (bytes memory) {
        bytes32 txId = getTxId(_target, _value, _fuc, _data, _timestamp);
        //check tx is queued
        if(!queued[txId]){
            revert NotQueuedError(txId);
        }
        //chech block.timestamp > _timpstamp
        if(block.timestamp < _timestamp){
            revert TimestampNotPassError(block.timestamp,_timestamp);
        }
        if(block.timestamp > _timestamp + GRACE_PERIOD){
            revert TimestampExpireError(block.timestamp,_timestamp + GRACE_PERIOD );
        }
        //delete the tx from queued
        queued[txId] = false;
        bytes memory data;
        if(bytes(_fuc).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_fuc))),_data);
        }else {
            data = _data;
        }
        //executed the tx
       (bool ok, bytes memory res) = _target.call{value: _value}(data);
       if(!ok) {
           revert TxFailedError();
       }
       emit Execute(txId, _target, _value, _fuc, _data, _timestamp);
    }   
    function cancel(bytes32 _txId) external OnlyOwner {
        if(!queued[_txId]){
            revert NotQueuedError(_txId);
        }
        queued[_txId] = false; 
        emit Cancel(_txId);
    }
}
contract TextTimeLock {
    address public timeLock;
    constructor(address _timeLock) {
        timeLock = _timeLock;
    }
    function text() external {
        require(timeLock == msg.sender,"not timelock conctract");
    }
    function Gettimestamp() external view returns (uint) {  

        return block.timestamp + 100;
    }
}