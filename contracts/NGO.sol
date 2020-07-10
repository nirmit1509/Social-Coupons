// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract NGO is ERC721 {

    constructor() public ERC721("Volunteer Coupon", "SC") {}

    uint public ngoCount = 0;

    struct structNGO {
        string reedNo;
        string ngoName;
        string founderName;
        address ngoFounder;
        string PAN;
        string ngoEmail;
        string ngoPhone;
        string location;
        string year;
    }

    mapping(uint => structNGO) public ngoList;
    mapping(address => bool) public ngoOwners;

    function registerNGO (
    string memory _reedNo, string memory _ngoName, string memory _founderName, string memory _PAN,
    string memory _ngoEmail, string memory _ngoPhone, string memory _location, string memory _year
    ) public {
        require(bytes(_reedNo).length > 0, "NGO Registration Reed number required...");
        require(bytes(_ngoName).length > 0, "NGO Name field cannot be empty...");
        require(bytes(_founderName).length > 0, "Name of Founder cannot be null...");
        require(bytes(_PAN).length > 0, "NGO PAN no required...");
        require(bytes(_ngoEmail).length > 0, "NGO Email field cannot be empty...");
        require(bytes(_ngoPhone).length > 0, "NGO Phone no. field cannot be empty...");
        require(bytes(_location).length > 0, "Address of NGO cannot be null...");
        require(bytes(_year).length > 0, "NGO Year of Establishment required...");
        ngoCount++;
        ngoList[ngoCount] = structNGO(_reedNo, _ngoName, _founderName, msg.sender, _PAN, _ngoEmail, _ngoPhone, _location, _year);
        ngoOwners[msg.sender] = true;
    }

    function retrieveNGODetails (uint _ngoId) public view returns
    (string memory reedNo, string memory ngoName, string memory founderName, address ngoFouner, string memory PAN,
    string memory ngoEmail, string memory ngoPhone, string memory location, string memory year) {
        structNGO memory n = ngoList[_ngoId];
        return (n.reedNo, n.ngoName, n.founderName, n.ngoFounder, n.PAN, n.ngoEmail, n.ngoPhone, n.location, n.year);
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    function issueCoupon(address _receiver, string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_receiver, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }


    uint public eventCount = 0;

    struct Event {
        string eventName;
        string eventDate;
        uint eventHours;
        uint eventAmount;
        address eventOrganizer;
        bool isValid;
    }

    mapping(uint => Event) public events;

    event EventAdded(
        string eventName,
        string eventDate,
        uint eventHours,
        uint eventAmount,
        address eventOrganizer,
        bool isValid
    );

    event EventEnded(
        uint eventId,
        bool isValid
    );

    function addEvents(string memory _eventName, string memory _eventDate, uint _hours, uint _amount) public {
        require(bytes(_eventName).length > 0, "Event Name field cannot be empty...");
        require(bytes(_eventDate).length > 0, "Event Date field cannot be empty...");
        require(ngoOwners[msg.sender], "Only NGO Owners can create events...");
        eventCount++;
        events[eventCount] = Event(_eventName, _eventDate, _hours, _amount, msg.sender, true);
        emit EventAdded(_eventName, _eventDate, _hours, _amount, msg.sender, true);
    }

    function endEvent(uint _eventId) public {
        require(eventExists(_eventId), "Event does not exist or has been ended already...");
        Event storage e = events[_eventId];
        e.isValid = false;
        emit EventEnded(_eventId, e.isValid);
    }

    function retrieveEventDetails(uint _eventId) public view returns
     (string memory eventName, string memory eventDate, address eventOrganizer) {
        Event memory e = events[_eventId];
        return (e.eventName, e.eventDate, e.eventOrganizer);
    }

    function eventExists(uint _eventId) public view returns (bool isValid) {
        Event memory e = events[_eventId];
        return (e.isValid);
    }
}