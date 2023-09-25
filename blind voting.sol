// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract BlindAuction {
    
    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }
    address payable public beneficiary;
    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;
    mapping (address => Bid[]) public bids;
    address public heighestBidder;
    uint public heighestBid;
    mapping (address => uint)pendingReturn;
    error TooLate(uint time);
    error TooEarly(uint time);
    modifier onlyBefore(uint time) {
        if(block.timestamp >= time)revert TooLate(time);
        _;
    }
    modifier tooEarly(uint time){
        if(block.timestamp <= time)revert TooEarly(time);
        _;
    }
    event AuctionEnded(address bidder, uint amount);
    error AuctionEndAlreadyCalled();
    constructor(
        uint biddingTime,
        uint revealTime,
        address payable beneficiaryAddress) {
        beneficiary = beneficiaryAddress;
        biddingEnd =  block.timestamp + biddingTime;
        revealEnd = biddingEnd + revealTime;
    }
    function bid(bytes32 _blindedBid) external payable onlyBefore(biddingEnd){
        bids[msg.sender].push(Bid({
            blindedBid: _blindedBid,
            deposit: msg.value
        }));
    }
    function reveal(
        uint[] calldata values,
        bool[] calldata fakes, 
        bytes32[] calldata secrets
    ) external 
    onlyBefore(biddingEnd)
    tooEarly(revealEnd) {
        uint length = bids[msg.sender].length;
        require(values.length == length);
        require(fakes.length == length);
        require(secrets.length == length);
        uint refund;
        for (uint i=0; i < length; i++) 
        {
            Bid storage bidToCheck = bids[msg.sender][i];
            (uint value,bool fake, bytes32 secret) =
            (values[i], fakes[i], secrets[i]);
            if (bidToCheck.blindedBid != keccak256(abi.encodePacked(value,fake, secret))){
                continue;
            } 
            refund += bidToCheck.deposit;
            if(!fake && bidToCheck.deposit >= value){
                if(placeBid(msg.sender ,value)){
                    refund -= value;
                }
            }
             bidToCheck.blindedBid = bytes32(0);
        }
          payable(msg.sender).transfer(refund);
    }   
    function withdraw() external {
        uint amount = pendingReturn[msg.sender];
        if (amount > 0){
            pendingReturn[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
        
    }
    function auctionend() external onlyBefore(biddingEnd) {
        if(ended)revert AuctionEndAlreadyCalled();
         emit AuctionEnded(heighestBidder, heighestBid);
         ended = true;
         beneficiary.transfer(heighestBid);
        
    }
    function placeBid(address bidder, uint value) internal
            returns (bool success) {
        if(value <= heighestBid){
            return false;
        }
        if(heighestBidder != address(0)){
            pendingReturn[heighestBidder] += heighestBid;
        }
        heighestBid = value;
        heighestBidder = bidder;
        return true;
    }

    function hashBid(uint value,
        bool fake, 
        bytes32 secret) external pure returns(bytes32) {
            return keccak256(abi.encodePacked(value, fake, secret));
        }

}