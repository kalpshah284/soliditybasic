// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract Purchase {
    uint public value;
    address payable public buyer;
    address payable public seller;
    enum State{Created, Locked, Release, Inactive}
     State public state;
     error ValueNotEven();
     error OnlySeller();
     error InvalidState();
     error OnlyBuyer();
     event Aborted();
     event PurchaseConfirmed();
     event ItemReceived();
     event SellerRefunded();
     modifier onlySeller() {
         if(seller != msg.sender)
         revert OnlySeller();
         _;
     }
     modifier inState(State state_) {
        if (state != state_)
            revert InvalidState();
        _;
    }
    modifier condition(bool condition_) {
        require(condition_);
        _;
    }
     modifier onlyBuyer() {
        if (msg.sender != buyer)
            revert OnlyBuyer();
        _;
    }

    constructor() payable {
        seller = payable (msg.sender);
        value = msg.value / 2;
        if ((2 * value) != msg.value)
            revert ValueNotEven();

    }
    function abort() external 
        onlySeller
        inState(State.Created){
             emit Aborted();
             state = State.Inactive;
             seller.transfer(address(this).balance);

    }
    function confirmPurchase() 
    external
    inState(State.Created)
        condition(msg.value == (2 * value))
        payable {
        emit PurchaseConfirmed();
        buyer = payable(msg.sender);
        state = State.Locked;
        
    }
     function confirmReceived()
        external
        onlyBuyer
        inState(State.Locked)
    {
        emit ItemReceived();
        state = State.Release;
        buyer.transfer(value);
    }    
    function refundSeller()
        external
        onlySeller
        inState(State.Release)
    {
        emit SellerRefunded();
        state = State.Inactive;
        seller.transfer(3 * value);
    }
}