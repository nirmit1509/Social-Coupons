// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
//NGO.sol is imported to check whether event exists or not for which volunteer wishes to register
import "./NGO.sol";

contract Volunteer is ERC721, NGO {

    struct structVolunteer {
        string volName;
        string aadhar;
        string bloodGroup;
        string location;
        address volAddress;
        string organization;
    }

    mapping(address => structVolunteer) public volunteers;
    mapping(address => uint) public registeredVolunteers;

    event VolunteerRegistered(
        string volName,
        string aadhar,
        string bloodGroup,
        string location,
        address volAddress,
        string organization
    );

    function registerVolunteer (
    string memory _volName, string memory _aadhar, string memory _bloodGroup, string memory _location,
    string memory _organization) public {
        require(bytes(_volName).length > 0, "Volunteer Name field cannot be empty...");
        require(bytes(_aadhar).length > 0, "Volunteer Aadhar Card Number required...");
        require(bytes(_bloodGroup).length > 0, "Volunteer Blood Group required...");
        require(bytes(_location).length > 0, "Volunteer location field cannot be empty...");
        require(bytes(_organization).length > 0, "Organization field cannot be empty...");
        volunteers[msg.sender] = structVolunteer(_volName, _aadhar, _bloodGroup, _location, msg.sender, _organization);
        emit VolunteerRegistered(_volName, _aadhar, _bloodGroup, _location, msg.sender, _organization);
    }

    function registerVolunteer4Events(uint _eventId) public {
        require(eventExists(_eventId), "this event does not exists..");
        registeredVolunteers[msg.sender] = _eventId;
    }

    function redeemCoupon(address _cottage, uint _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "You are not the owner of this coupon...");
        // check if _tokenId still exists or not
        require(_exists(_tokenId), "Token Id does not exists");
        // transfer coupon to cottage after purchasing product
        _transfer(msg.sender, _cottage, _tokenId);
    }
}