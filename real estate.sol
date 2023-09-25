// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShoppingApp {
    struct Product {
        uint256 id;
        string name;
        uint256 price;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCount;

    constructor() {
        productCount = 0;
    }

    function addProduct(string memory _name, uint256 _price) public {
        productCount++;
        products[productCount] = Product(productCount, _name, _price);
    }

    function getProduct(uint256 _id) public view returns (uint256, string memory, uint256) {
        require(_id > 0 && _id <= productCount, "Invalid product ID");
        Product memory product = products[_id];
        return (product.id, product.name, product.price);
    }
}
