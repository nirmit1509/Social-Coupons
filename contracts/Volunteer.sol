// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
//NGO.sol is imported to check whether event exists or not for which volunteer wishes to register
import "./NGO.sol";

contract Volunteer is ERC721, NGO {

    // Defines the structure of a Volunteer (i.e. requirements for registration of a new Volunteer)
    struct structVolunteer {
        string volName;
        string aadhar;
        string bloodGroup;
        string location;
        address volAddress;
        string organization;
    }

    // Variable used to track IDs of registered Volunteers
    uint public volCount = 0;

    // Mapping from registered Volunteer ID to approved/registered Volunteers
    mapping(uint => structVolunteer) public volunteersById;

    // Mapping from registered Volunteer ethereum addresses to approved/registered Volunteers
    mapping(address => structVolunteer) public volunteersByAddress;

    // Mapping from registered Volunteer ethereum addresses to event IDs they participated in recently
    mapping(address => uint) public registeredVolunteers;

    // Volunteer details to be emitted after a specific task is accomplished
    event VolunteerRegistered(
        uint volId,
        string volName,
        string aadhar,
        string bloodGroup,
        string location,
        address volAddress,
        string organization
    );


    /**
     * @dev Emits Volunteer details after a volunteer has successfully registered.
     *
     * Requirements :
     * - Name of Volunteer
     * - Aadhar number of Volunteer
     * - Blood Group of Volunteer
     * - Residence/location of Volunteer
     * - Contact no of NGO
     * - Location of NGO
     * - Year in which NGO was founded
     */
    function registerVolunteer (
    string memory _volName, string memory _aadhar, string memory _bloodGroup, string memory _location,
    string memory _organization) public {
        require(bytes(_volName).length > 0, "Volunteer Name field cannot be empty...");
        require(bytes(_aadhar).length > 0, "Volunteer Aadhar Card Number required...");
        require(bytes(_bloodGroup).length > 0, "Volunteer Blood Group required...");
        require(bytes(_location).length > 0, "Volunteer location field cannot be empty...");
        require(bytes(_organization).length > 0, "Organization field cannot be empty...");
        volCount++;
        volunteersById[volCount] = structVolunteer(_volName, _aadhar, _bloodGroup, _location, msg.sender, _organization);
        volunteersByAddress[msg.sender] = structVolunteer(_volName, _aadhar, _bloodGroup, _location, msg.sender, _organization);
        emit VolunteerRegistered(volCount, _volName, _aadhar, _bloodGroup, _location, msg.sender, _organization);
    }


    /**
     * @dev Register Volunteer for an event (if event exists).
     *
     * Requirements :
     * - Event ID of event volunteer wish to register for
     */
    function registerVolunteer4Events(uint _eventId) public {
        require(eventExists(_eventId), "this event does not exists..");
        registeredVolunteers[msg.sender] = _eventId;
    }


    /**
     * @dev Transfers coupon to cottage owner when item is purchased
     *
     * Requirements :
     * - Ethereum address of Cottage Industry
     * - Token ID of token
     */
    function redeemCoupon(address _cottage, uint _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "You are not the owner of this coupon...");
        // check if _tokenId still exists or not
        require(_exists(_tokenId), "Token Id does not exists");
        // transfer coupon to cottage after purchasing product
        _transfer(msg.sender, _cottage, _tokenId);
    }
}