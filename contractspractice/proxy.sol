// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract couterV1 {
    uint public count;
    address public Implementation;
    address public admin;
    function inc() external {
        count += 1;
    }
}
contract couterV2 {
    uint public count;
    address public Implementation;
    address public admin;
    function inc() external {
        count += 1;
    }
    function dec() external {
        count -= 1;
    }
}
contract BuggyProxy {
    address public Implementation;
    address public admin;
    constructor(){
        admin = msg.sender;
    }
    function _delegate (address _implementation) private {
         assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
        // (bool success, bytes data) = implemenatation.delegatecall{gas: , value: }()
    
    }
    fallback() external payable {
        _delegate(Implementation);
    }
    receive() external payable {
        _delegate(Implementation);
    }
    
    function upgradeTo(address _Implementation) external {
        require(admin == msg.sender,"not admin");
        Implementation = _Implementation;
    }
}
library storageSlot {
    struct AddressSlot{
        address value;
    }
    function getAddressSlot(bytes32 Slot) internal pure returns (AddressSlot storage r){
        assembly {
            r.slot := Slot

        }
    }
}
contract TestSlot {
    bytes32 public constant SLOT = keccak256("TEST _SLOT");
    function getSlot() external view returns (address){
        return storageSlot.getAddressSlot(SLOT).value;
    }
    function writeSlot(address _addr) external {
        storageSlot.getAddressSlot(SLOT).value = _addr;
    }
}


608060405234801561001057600080fd5b5033600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506103c2806100616000396000f3fe6080604052600436106100385760003560e01c80633659cfe614610093578063e6a8ee4f146100bc578063f851a440146100e757610068565b366100685761006660008054906101000a900473ffffffffffffffffffffffffffffffffffffffff16610112565b005b61009160008054906101000a900473ffffffffffffffffffffffffffffffffffffffff16610112565b005b34801561009f57600080fd5b506100ba60048036038101906100b591906102b8565b610138565b005b3480156100c857600080fd5b506100d161020b565b6040516100de91906102f4565b60405180910390f35b3480156100f357600080fd5b506100fc61022f565b60405161010991906102f4565b60405180910390f35b3660008037600080366000845af43d6000803e8060008114610133573d6000f35b3d6000fd5b3373ffffffffffffffffffffffffffffffffffffffff16600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16146101c8576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016101bf9061036c565b60405180910390fd5b806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006102858261025a565b9050919050565b6102958161027a565b81146102a057600080fd5b50565b6000813590506102b28161028c565b92915050565b6000602082840312156102ce576102cd610255565b5b60006102dc848285016102a3565b91505092915050565b6102ee8161027a565b82525050565b600060208201905061030960008301846102e5565b92915050565b600082825260208201905092915050565b7f6e6f742061646d696e0000000000000000000000000000000000000000000000600082015250565b600061035660098361030f565b915061036182610320565b602082019050919050565b6000602082019050818103600083015261038581610349565b905091905056fea26469706673582212206eecf2d4c0da67d1e0be2e4f063cd899db62f94f1e66576c4e3d542dc5847afb64736f6c63430008120033