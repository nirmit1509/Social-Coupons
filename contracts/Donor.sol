// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract Donor {

    // Variable used to track IDs of registered Donors
    uint public donorCount = 0;

    // Defines the structure of a Donor (i.e. requirements for registration of a new Donor)
    struct structDonor {
        string name;
        string aadhar;
        string typeOfDonor; // Individual or Organization
        string organization;
        string location; // address of Donor
        string PAN;
    }

    // Mapping from registered Donor ID to registered Donors
    mapping(uint => structDonor) public donors;


    /**
     * @dev Returns a unique Donor ID after a donor has been successfully registered.
     *
     * Requirements :
     * - Name of Donor
     * - Aadhar number of Donor
     * - Type of Donor i.e. Individual or Organization
     * - Name of Organization if donor is not of type "Individual"
     * - Residence address of Donor
     * - PAN number of Donor
     */
    function registerDonor (
    string memory _name, string memory _aadhar, string memory _type, string memory _organization, string memory _location, string memory _PAN
    ) public returns (uint donorId){
        require(bytes(_name).length > 0, "Donor name required...");
        require(bytes(_aadhar).length > 0, "Donor Aadhar Card Number required...");
        require(bytes(_location).length > 0, "Donor's location required...");
        require(bytes(_PAN).length > 0, "Donor PAN Card Number required...");
        if(keccak256(bytes(_type)) == keccak256(bytes("Individual"))) {
            donorCount++;
            donors[donorCount] = structDonor(_name, _aadhar, _type, "", _location, _PAN);
        }
        else if (keccak256(bytes(_type)) == keccak256(bytes("Organization"))){
            require(bytes(_organization).length > 0, "Donor Organization required...");
            donorCount++;
            donors[donorCount] = structDonor(_name, _aadhar, _type, _organization, _location, _PAN);
        }
        return donorCount;
    }


    // Variable used to track Transaction IDs
    uint public transactionId = 0;

    // Defines the structure of an individual Transaction
    struct Transaction {
        address sender;
        address receiver;
        string currency;
        uint amount;
    }

    // Mapping from transaction ID to approved Transaction Details
    mapping (uint => Transaction) public transactions;

    // Transaction details to be emitted after fund has been successfully transferred.
    event FundTransferred (
        uint transactionId,
        address sender,
        address receiver,
        string currency,
        uint amount
    );


    /**
     * @dev Emits Transaction details after a fund has been successfully transferred.
     *
     * Requirements :
     * - Registration Deed no
     * - Name of NGO
     * - Name of NGO's Founder
     * - PAN number of NGO
     * - Email ID of NGO
     * - Contact no of NGO
     * - Location of NGO
     * - Year in which NGO was founded
     */
    function fundTransfer (address _sender, address _receiver, string memory _currency, uint _amount) public {
        require(_amount > 0, "Amount cannot be null...");
        require(bytes(_currency).length > 0, "Currency Type not mentioned...");
        transactionId++;
        transactions[transactionId] = Transaction(_sender, _receiver, _currency,  _amount);
        emit FundTransferred(transactionId, _sender, _receiver, _currency, _amount);
    }


    function finalSettlement (address _ngoAccount, address _cottageAccount, string memory _currency, uint _amount) public {
        payToCottage(_ngoAccount, _cottageAccount, _currency, _amount);
    }

    function payToCottage(address _sender, address _receiver, string memory _currency, uint _amount) internal {
        fundTransfer(_sender, _receiver, _currency, _amount);
    }
}