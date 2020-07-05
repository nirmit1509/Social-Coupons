// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract Cottage is ERC721 {

    constructor() public ERC721("Volunteer Coupon", "SC") {}

    uint cottageCount = 0;

    struct structCottage {
        uint cottageId;
        string cottageName;
        string cottageLocation;
        address cottageOwner;
    }

    mapping(uint => structCottage) public cottages;

    function registerCottage (string memory _name, string memory _location) public {
        require(bytes(_name).length > 0, "Cottage Name field cannot be empty...");
        require(bytes(_location).length > 0, "Cottage Location field cannot be empty...");
        cottageCount++;
        cottages[cottageCount] = structCottage(cottageCount, _name, _location, msg.sender);
    }

    function retrieveCottageDetails (uint _cottageId) public view returns
     (uint cottageId, string memory cottageName, string memory cottageLocation, address cottageFounder) {
        structCottage memory c = cottages[_cottageId];
        return (c.cottageId, c.cottageName, c.cottageLocation, c.cottageOwner);
    }

    function settlement(uint _tokenId) public {
        // check if _tokenId exists
        require(_exists(_tokenId), "Token Id does not exists");
        // burn will destroy the tokenId of coupon, so it will no longer exist and NGO can pay cottage accordingly
        _burn(_tokenId);
    }

    uint prodCount = 0;

    struct Product {
        uint prodId;
        string prodName;
        uint prodPrice;
        uint quantity;
    }

    mapping(uint => Product) public products;

    function registerProduct(string memory _prodName, uint _prodPrice, uint _quantity) public {
        require(bytes(_prodName).length > 0, "Product Name field cannot be empty...");
        require(_prodPrice > 0, "Product Price invalid...");
        require(_quantity > 0, "Product quantity invalid...");
        prodCount++;
        products[prodCount] = Product(prodCount, _prodName, _prodPrice, _quantity);
    }

    function sellProduct(uint _prodId, uint _quantity) public returns (uint totalPrice) {
        Product storage p = products[_prodId];
        require(p.quantity >= _quantity, "Sorry, we don't have enough products...");
        p.quantity -= _quantity;
        return (_quantity*p.prodPrice);
    }
}