// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract GCDTest {

    //this function calculates the GCD (Greatest Common Divisor)
    function gcd(uint a, uint b) public pure returns (uint) {
        uint i = a;
        uint j = b;
        if(a <= b){
            for(i = a; i > 1; i--){
                if(a % i == 0 && b % i == 0){
                    return i;
                }
            }
            return i;
        }
        else if(a > b){
            for(j = b; j > 1; j--){
                if(a % j == 0 && b % j == 0){
                    return j;
                }
            }
            return j;
        }

        
    }

}