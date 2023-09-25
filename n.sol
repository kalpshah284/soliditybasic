// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Enum {
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    Status public status;
    uint256 public lastUpdateTime;

    modifier updateStatusEvery100Seconds() {
        require(
            block.timestamp >= lastUpdateTime + 50 seconds,
            "Can only update status every 50 seconds"
        );
        _;
        lastUpdateTime = block.timestamp;
    }

    function set(Status _status) public updateStatusEvery100Seconds {
        status = _status;
    }

    function updateStatusAutomatically() public {
        require(block.timestamp >= lastUpdateTime + 50 seconds, "Not enough time has passed since the last update");
        uint256 timeSinceLastUpdate = block.timestamp - lastUpdateTime;
        uint256 numberOfUpdates = timeSinceLastUpdate / 50 seconds;

        for (uint256 i = 0; i < numberOfUpdates; i++) {
            if (status != Status.Canceled) {
                // Increment the status by one
                status = Status(uint256(status) + 1);
            }
        }

        lastUpdateTime = block.timestamp;
    }
    

}
