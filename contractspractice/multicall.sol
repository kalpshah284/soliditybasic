// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
contract TestMultiCall {
    function fun1() external view returns (uint, uint){
        return (1,block.timestamp);
    }
    function fun2() external view returns (uint, uint){
        return (2,block.timestamp);
    }
    function getdata1() external pure returns (bytes memory){
        return abi.encodeWithSelector(this.fun1.selector);
    }
    function getdata2() external pure returns (bytes memory){
        return abi.encodeWithSelector(this.fun2.selector);
    }
}

contract MultiCall {
    function multicall(address[] calldata targets, bytes[] calldata data)
    external 
    view 
    returns (bytes[] memory ){
        require(targets.length == data.length,"targets.length != data.length");
        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < targets.length; i++)                                                                     
        {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "Call fail");  
            results[i] = result;
        }
        return results;
    }
    
}