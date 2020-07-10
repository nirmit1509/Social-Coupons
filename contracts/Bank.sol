// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract Bank {
    uint public donorCount = 0;

    struct Donor {
        string name;
        string aadhar;
        string organization;
        string location; // address of Donor
        string PAN;
    }

    mapping(uint => Donor) public donors;

    function registerDonor (
    string memory _name, string memory _aadhar, string memory _organization, string memory _location, string memory _PAN
    ) public {
        require(bytes(_name).length > 0, "Donor name required...");
        require(bytes(_aadhar).length > 0, "Donor Aadhar Card Number required...");
        require(bytes(_organization).length > 0, "Donor Organization required...");
        require(bytes(_location).length > 0, "Donor's location required...");
        require(bytes(_PAN).length > 0, "Donor PAN Card Number required...");
        donorCount++;
        donors[donorCount] = Donor(_name, _aadhar, _organization, _location, _PAN);
    }

    uint public transactionId = 0;

    struct Transaction {
        address sender;
        address receiver;
        uint amount;
    }

    mapping (uint => Transaction) public transactions;

    event FundTransferred (
        address sender,
        address receiver,
        uint amount
    );

    function fundTransfer (address _sender, address _receiver, uint _amount) public {
        require(_amount > 0, "Amount cannot be null...");
        transactionId++;
        transactions[transactionId] = Transaction(_sender, _receiver, _amount);
        emit FundTransferred(_sender, _receiver, _amount);
    }

    function finalSettlement (address _ngoAccount, address _cottageAccount, uint _amount) public {
        payToCottage(_ngoAccount, _cottageAccount, _amount);
    }

    function payToCottage(address _sender, address _receiver, uint _amount) internal {
        require(_amount > 0, "Amount cannot be null...");
        transactionId++;
        transactions[transactionId] = Transaction(_sender, _receiver, _amount);
        emit FundTransferred(_sender, _receiver, _amount);
    }
}