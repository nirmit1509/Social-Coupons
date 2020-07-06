// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract NGO is ERC721 {

    constructor() public ERC721("Volunteer Coupon", "SC") {}

    uint public ngoCount = 0;

    struct structNGO {
        string ngoName;
        address ngoFounder;
        string ngoEmail;
        string ngoPhone;
    }

    mapping(uint => structNGO) public ngoList;
    mapping(address => bool) public ngoOwners;

    function registerNGO (string memory _ngoName, string memory _ngoEmail, string memory _ngoPhone) public {
        require(bytes(_ngoName).length > 0, "NGO Name field cannot be empty...");
        require(bytes(_ngoEmail).length > 0, "NGO Email field cannot be empty...");
        require(bytes(_ngoPhone).length > 0, "NGO Phone no. field cannot be empty...");
        ngoCount++;
        ngoList[ngoCount] = structNGO(_ngoName, msg.sender, _ngoEmail, _ngoPhone);
        ngoOwners[msg.sender] = true;
    }

    function retrieveNGODetails (uint _ngoId) public view returns
     (string memory ngoName, address ngoFounder, string memory ngoEmail, string memory ngoPhone) {
        structNGO memory n = ngoList[_ngoId];
        return (n.ngoName, n.ngoFounder, n.ngoEmail, n.ngoPhone);
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
