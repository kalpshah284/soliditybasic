// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract Array {
    uint[] public arr;

    function push(uint i) public {
        arr.push(i);
    }
    function get(uint i) public view returns (uint) {
        return arr[i];
    }
    function getArr() public view returns (uint[] memory) {
        return arr;
    }
    function pop() public {
        arr.pop();
    }
    function remove(uint i) public {
         delete arr[i];
    }
    function Length() public view returns (uint) {
        return arr.length;
    }
    function loop() public  {
        for (uint i; i < arr.length - 1; i++){
            arr[i] = arr[i + 1];
        }
    }
}