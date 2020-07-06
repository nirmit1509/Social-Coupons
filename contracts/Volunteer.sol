// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
//NGO.sol is imported to check whether event exists or not for which volunteer wishes to register
import "./NGO.sol";

contract Volunteer is ERC721, NGO {

    struct structVolunteer {
        string volName;
        string location;
        address volAddress;
    }

    mapping(address => structVolunteer) public volunteers;
    mapping(address => uint) public registeredVolunteers;

    event VolunteerRegistered(
        string volName,
        string location,
        address volAddress
    );

    function registerVolunteer (string memory _volName, string memory _location) public {
        require(bytes(_volName).length > 0, "Volunteer Name field cannot be empty...");
        require(bytes(_location).length > 0, "Volunteer location field cannot be empty...");
        volunteers[msg.sender] = structVolunteer(_volName, _location, msg.sender);
        emit VolunteerRegistered(_volName, _location, msg.sender);
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