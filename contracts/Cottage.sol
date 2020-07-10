// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract Cottage is ERC721 {

    constructor() public ERC721("Volunteer Coupon", "SC") {}

    uint public cottageCount = 0;

    struct structCottage {
        string registrationId;
        string cottageName;
        string location;
        address cottageOwner;
        string year;
        string uniqueId; // PAN or Aadhar
        string category;
    }

    mapping(uint => structCottage) public cottages;
    mapping(address => structCottage) public cottagesByAddress;

    function registerCottage (
    string memory _regId, string memory _name, string memory _location,
    string memory _year, string memory _uniqueId, string memory _category
    ) public {
        require(bytes(_regId).length > 0, "Cottage Registraion ID required...");
        require(bytes(_name).length > 0, "Cottage Name field cannot be empty...");
        require(bytes(_location).length > 0, "Cottage Location field cannot be empty...");
        require(bytes(_year).length > 0, "Cottage Year of Establishment cannot be null...");
        require(bytes(_uniqueId).length > 0, "PAN number or Aadhar number is must...");
        require(bytes(_category).length > 0, "Cottage Category field cannot be empty...");
        cottageCount++;
        cottages[cottageCount] = structCottage(_regId, _name, _location, msg.sender, _year, _uniqueId, _category);
        cottagesByAddress[msg.sender] = structCottage(_regId, _name, _location, msg.sender, _year, _uniqueId, _category);
    }

    function retrieveCottageDetails (uint _cottageId) public view returns
    (string memory registrationId, string memory cottageName, string memory location, address cottageOwner,
    string memory year, string memory uniqueId, string memory category) {
        structCottage memory c = cottages[_cottageId];
        return (c.registrationId, c.cottageName, c.location, c.cottageOwner, c.year, c.uniqueId, c.category);
    }

    function settlement(uint _tokenId) public {
        // check if _tokenId exists
        require(_exists(_tokenId), "Token Id does not exists");
        // burn will destroy the tokenId of coupon, so it will no longer exist and NGO can pay cottage accordingly
        _burn(_tokenId);
    }

    uint public prodCount = 0;

    struct Product {
        uint prodId;
        string prodName;
        uint prodPrice;
        uint quantity;
        address producer;
        string techSpecifications;
        string otherInfo;
        string industryName;
        string reviews;
        bool exists;
    }

    mapping(uint => Product) public products;

    function registerProduct (
        string memory _prodName, uint _prodPrice, uint _quantity, string memory _tech,
        string memory _otherInfo, string memory _industryName, string memory _reviews
        ) public {
        require(bytes(_prodName).length > 0, "Product Name field cannot be empty...");
        require(_prodPrice > 0, "Product Price invalid...");
        require(_quantity > 0, "Product quantity invalid...");
        prodCount++;
        products[prodCount] = Product(prodCount, _prodName, _prodPrice, _quantity, msg.sender, _tech, _otherInfo, _industryName, _reviews, true);
    }

    function updateProduct (
        uint _prodId, string memory _prodName, uint _prodPrice, uint _quantity, address _producer,
        string memory _tech, string memory _otherInfo, string memory _industryName, string memory _reviews
        ) public {
        require(!ProdExists(_prodId), "Cannot update a Product that doesn't exists");
        require(bytes(_prodName).length > 0, "Product Name field cannot be empty...");
        require(_prodPrice > 0, "Product Price invalid...");
        require(_quantity > 0, "Product quantity invalid...");
        Product storage p = products[_prodId];
        p.prodName = _prodName;
        p.prodPrice = _prodPrice;
        p.quantity = _quantity;
        p.producer = _producer;
        p.techSpecifications = _tech;
        p.otherInfo = _otherInfo;
        p.industryName = _industryName;
        p.reviews = _reviews;
    }

    function retrieveProductDetails (uint _prodId) public view returns
    (string memory prodName, uint prodPrice, uint quantity, address prodOwner, string memory location) {
        require(ProdExists(_prodId), "Product doesn't exists");
        Product memory p = products[_prodId];
        structCottage memory c = cottagesByAddress[p.producer];
        return (p.prodName, p.prodPrice, p.quantity, c.cottageOwner, c.location);
    }

    function addProduct(uint _prodId, uint _quantity) public {
        require(ProdExists(_prodId), "Product doesn't exists");
        Product storage p = products[_prodId];
        p.quantity += _quantity;
    }

    function sellProduct(uint _prodId, uint _quantity) public returns (uint totalPrice) {
        require(ProdExists(_prodId), "Product doesn't exists");
        Product storage p = products[_prodId];
        require(p.quantity >= _quantity, "Sorry, we don't have enough products...");
        p.quantity -= _quantity;
        return (_quantity*p.prodPrice);
    }

    function removeProduct(uint _prodId) public {
        require(ProdExists(_prodId), "Product doesn't exists");
        Product storage p = products[_prodId];
        p.exists = false;
    }

    function ProdExists(uint _prodId) public view returns(bool) {
        Product memory p = products[_prodId];
        return p.exists;
    }
}