// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract Cottage is ERC721 {

    constructor() public ERC721("Volunteer Coupon", "SC") {}

    uint cottageCount = 0;

    struct structCottage {
        string cottageName;
        string cottageLocation;
        address cottageOwner;
    }

    mapping(uint => structCottage) public cottages;
    mapping(address => structCottage) public cottagesByAddress;

    function registerCottage (string memory _name, string memory _location) public {
        require(bytes(_name).length > 0, "Cottage Name field cannot be empty...");
        require(bytes(_location).length > 0, "Cottage Location field cannot be empty...");
        cottageCount++;
        cottages[cottageCount] = structCottage(_name, _location, msg.sender);
        cottagesByAddress[msg.sender] = structCottage(_name, _location, msg.sender);
    }

    function retrieveCottageDetails (uint _cottageId) public view returns
     (string memory cottageName, string memory cottageLocation, address cottageOwner) {
        structCottage memory c = cottages[_cottageId];
        return (c.cottageName, c.cottageLocation, c.cottageOwner);
    }

    function settlement(uint _tokenId) public {
        // check if _tokenId exists
        require(_exists(_tokenId), "Token Id does not exists");
        // burn will destroy the tokenId of coupon, so it will no longer exist and NGO can pay cottage accordingly
        _burn(_tokenId);
    }

    uint prodCount = 0;

    struct Product {
        string prodName;
        uint prodPrice;
        uint quantity;
        address producer;
    }

    mapping(uint => Product) public products;

    function registerProduct(string memory _prodName, uint _prodPrice, uint _quantity) public {
        require(bytes(_prodName).length > 0, "Product Name field cannot be empty...");
        require(_prodPrice > 0, "Product Price invalid...");
        require(_quantity > 0, "Product quantity invalid...");
        prodCount++;
        products[prodCount] = Product(_prodName, _prodPrice, _quantity, msg.sender);
    }

    function retrieveProductDetails (uint _prodId) public view returns
     (string memory prodName, uint prodPrice, uint quantity, address prodOwner, string memory location) {
        Product memory p = products[_prodId];
        structCottage memory c = cottagesByAddress[p.producer];
        return (p.prodName, p.prodPrice, p.quantity, c.cottageOwner, c.cottageLocation);
    }

    function sellProduct(uint _prodId, uint _quantity) public returns (uint totalPrice) {
        Product storage p = products[_prodId];
        require(p.quantity >= _quantity, "Sorry, we don't have enough products...");
        p.quantity -= _quantity;
        return (_quantity*p.prodPrice);
    }
}