// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract SimpleAuction {
    address payable public beneficiary;
    uint public auctionEndTime;
    address public highestBidder;
    uint public highestBid;
    mapping (address => uint) public pendingReturns;
    bool Ended;
    error AuctionAlreadyEnded();
    error BidNotHighEnough(uint highestBid);
    error AuctionNotYetEnded();
    error AuctionEndAlreadyCalled();
    event HighestBidIncreased(address Bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    constructor(address payable _beneficiary,  uint biddingTime) {
        beneficiary = _beneficiary;
        auctionEndTime = biddingTime + block.timestamp;

    }
    function bid() external payable {
        if(auctionEndTime < block.timestamp){
            revert AuctionAlreadyEnded();
        }
        if (msg.value <= highestBid){
             revert BidNotHighEnough(highestBid);
        }
        if (highestBid != 0){
             pendingReturns[highestBidder] += highestBid;
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit HighestBidIncreased(msg.sender, msg.value);

    }
    function withdraw() external returns(bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0){
            pendingReturns[msg.sender];
        
            if(!payable (msg.sender).send(amount)){
                pendingReturns[msg.sender] = amount;
                return false;
            }  
        }
        return true;
    }
    function auctionEnd() external {
        if(block.timestamp < auctionEndTime){
        revert AuctionNotYetEnded();
        }
        if (Ended){
        revert AuctionEndAlreadyCalled();
        }
    Ended = true;
     emit AuctionEnded(highestBidder, highestBid);
     beneficiary.transfer(highestBid);

    }
}