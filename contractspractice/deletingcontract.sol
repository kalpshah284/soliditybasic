// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.10;
contract Kill {
    
    constructor() payable {
 
    }
    function kill() external {          
        selfdestruct(payable (msg.sender));
    }
    function testcall() external pure returns (uint) {
        return 123;
    }

}
contract Getether {
    function Get() external view returns (uint) {

        return address(this).balance;
        
    }

    function kill(Kill _kill) external {
        _kill.kill();
    }
    
}