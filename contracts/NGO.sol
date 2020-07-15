// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract NGO is ERC721 {

    constructor() public ERC721("Volunteer Coupon", "SC") {}

    // Variable used to track IDs of registered NGOs
    uint public ngoCount = 0;

    // Defines the structure of an NGO (requirements for registration of a new NGO)
    struct structNGO {
        string deedNo;
        string ngoName;
        string founderName;
        address ngoFounder;
        string PAN;
        string ngoEmail;
        string ngoPhone;
        string location;
        string year;
    }

    // Mapping from registered NGO ID to approved/registered NGOs
    mapping(uint => structNGO) public ngoList;

    // Mapping from registered NGO owners (ethereum addresses) to approved/registered NGOs
    mapping(address => bool) public ngoOwners;

    /**
     * @dev Returns `ngoId` of the recently registered NGO.
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
    function registerNGO (
        string memory _deedNo, string memory _ngoName, string memory _founderName, string memory _PAN,
        string memory _ngoEmail, string memory _ngoPhone, string memory _location, string memory _year
    ) public returns (uint ngoId) {
        require(bytes(_deedNo).length > 0, "NGO Registration Reed number required...");
        require(bytes(_ngoName).length > 0, "NGO Name field cannot be empty...");
        require(bytes(_founderName).length > 0, "Name of Founder cannot be null...");
        require(bytes(_PAN).length > 0, "NGO PAN no required...");
        require(bytes(_ngoEmail).length > 0, "NGO Email field cannot be empty...");
        require(bytes(_ngoPhone).length > 0, "NGO Phone no. field cannot be empty...");
        require(bytes(_location).length > 0, "Address of NGO cannot be null...");
        require(bytes(_year).length > 0, "NGO Year of Establishment required...");
        ngoCount++;
        ngoList[ngoCount] = structNGO(_deedNo, _ngoName, _founderName, msg.sender, _PAN, _ngoEmail, _ngoPhone, _location, _year);
        ngoOwners[msg.sender] = true;
        return ngoCount;
    }


    /**
     * @dev Returns Details of an NGO.
     *
     * Requirements :
     * - NGO ID generated at the time of registration
     */
    function retrieveNGODetails (uint _ngoId) public view returns
        (string memory deedNo, string memory ngoName, string memory founderName, address ngoFouner, string memory PAN,
        string memory ngoEmail, string memory ngoPhone, string memory location, string memory year)
    {
        structNGO memory n = ngoList[_ngoId];
        return (n.deedNo, n.ngoName, n.founderName, n.ngoFounder, n.PAN, n.ngoEmail, n.ngoPhone, n.location, n.year);
    }


    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;


    /**
     * @dev Returns `token Id` of the recently issued Coupon.
     *
     * Requirements :
     * - Ethereum address of receiver of Coupon
     * - token URI for creating ERC721 token
     */
    function issueCoupon(address _receiver, string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _mint(_receiver, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return tokenId;
    }

    // Variable used to track event IDs of newly created Events.
    uint public eventCount = 0;

    // Defines the structure of an event (requirements for creating a new event)
    struct Event {
        string eventName;
        string eventDate;
        uint eventHours;
        uint eventAmount;
        address eventOrganizer;
        bool isValid;
    }

    // Mapping from registered event ID to Events
    mapping(uint => Event) public events;

    event EventAdded(
        uint eventId,
        string eventName,
        string eventDate,
        uint eventHours,
        uint eventAmount,
        address eventOrganizer,
        bool isValid
    );


    /**
     * @dev Emits Event details after registering a new event along with `eventId`.
     *
     * Requirements :
     * - Name of Event
     * - Date of Event
     * - Estimated hours to be spent in an event
     * - Estimated amount to be spent in that event
     */
    function addEvents(string memory _eventName, string memory _eventDate, uint _hours, uint _amount) public {
        require(bytes(_eventName).length > 0, "Event Name field cannot be empty...");
        require(bytes(_eventDate).length > 0, "Event Date field cannot be empty...");
        require(ngoOwners[msg.sender], "Only NGO Owners can create events...");
        eventCount++;
        events[eventCount] = Event(_eventName, _eventDate, _hours, _amount, msg.sender, true);
        emit EventAdded(eventCount, _eventName, _eventDate, _hours, _amount, msg.sender, true);
    }


    /**
     * @dev Ends an event if not already ended
     *
     * Requirements :
     * - Event ID of event we wish to end
     */
    function endEvent(uint _eventId) public {
        require(eventExists(_eventId), "Event does not exist or has been ended already...");
        Event storage e = events[_eventId];
        e.isValid = false;
    }


    /**
     * @dev Returns Details of an Event.
     *
     * Requirements :
     * - Event ID generated at the time of registring event
     */
    function retrieveEventDetails(uint _eventId) public view returns
    (string memory eventName, string memory eventDate, address eventOrganizer)
    {
        Event memory e = events[_eventId];
        return (e.eventName, e.eventDate, e.eventOrganizer);
    }


    /**
     * @dev Returns whether an event is ongoing or has been ended already.
     *
     * Requirements :
     * - Event ID of event generated at the time of registring event
     */
    function eventExists(uint _eventId) public view returns (bool isValid) {
        Event memory e = events[_eventId];
        return (e.isValid);
    }
}