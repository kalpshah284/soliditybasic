// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract abiencode {
    struct Mystruct {
        string name;
        uint[2] nums;
    }
    function endode(
        uint x,
        address addr,
        
        Mystruct calldata myStruct
        ) external pure returns (bytes memory){
        return abi.encode(x, addr, arr, myStruct);
    }
     function decode(
        bytes calldata data
    )
        external
        pure
        returns (uint x, address addr, uint[] memory arr, Mystruct memory myStruct){
            (x, addr, arr, myStruct) = abi.decode(data, (uint, address, uint[], Mystruct));
        }
}