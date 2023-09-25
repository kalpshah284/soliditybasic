// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3;

contract AcceessControl {
    event GrandRole(bytes32 indexed role, address indexed  account);
    event RevokRole(bytes32 indexed role, address indexed  account);
    //role => accoont =.bool 
    mapping (bytes32 => mapping (address => bool)) public roles;

    bytes32 private constant Admin = keccak256(abi.encodePacked("Admin"));
    bytes32 private constant User = keccak256(abi.encodePacked("User"));

    modifier  onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    constructor() {
        _grandRole(Admin,msg.sender);
    }

    function _grandRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrandRole(_role, _account);

    }
    function granRole(bytes32 _role, address _account ) external onlyRole(Admin) {
        _grandRole(_role, _account);
    }

    function revokRole(bytes32 _role, address _account ) external onlyRole(Admin) {
     roles[_role][_account] = false;
        emit RevokRole(_role, _account);   
    }

} 


//bytes32: 0xa729ef4e25027bc652fc8b5c4d1d902947361fa7c8e7b4905e877823f27331b3
//bytes32: 0x59daf22c92a94d3cc0dd1160ba0b142bdd9a54f280fcfa7508a89db52d34fac0