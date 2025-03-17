// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract LandTitleManagement {
    struct LandTitle {
        uint256 id;
        string location;
        uint256 area;
        address owner;
        bool isVerified;
    }

    uint256 public nextId;
    address public admin;
    mapping(uint256 => LandTitle) public landTitles;
    mapping(address => bool) public verifiedSurveyors;

    event LandRegistered(uint256 id, address owner);
    event OwnershipTransferred(uint256 id, address newOwner);
    event LandVerified(uint256 id, address surveyor);
    event SurveyorAdded(address surveyor);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyVerifiedSurveyor() {
        require(verifiedSurveyors[msg.sender], "Only verified surveyors can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addSurveyor(address _surveyor) external onlyAdmin {
        verifiedSurveyors[_surveyor] = true;
        emit SurveyorAdded(_surveyor);
    }

    function registerLand(string memory _location, uint256 _area) external {
        landTitles[nextId] = LandTitle(nextId, _location, _area, msg.sender, false);
        emit LandRegistered(nextId, msg.sender);
        nextId++;
    }

    function transferOwnership(uint256 _id, address _newOwner) external {
        require(landTitles[_id].owner == msg.sender, "Only the owner can transfer ownership");
        landTitles[_id].owner = _newOwner;
        emit OwnershipTransferred(_id, _newOwner);
    }

    function verifyLand(uint256 _id) external onlyVerifiedSurveyor {
        landTitles[_id].isVerified = true;
        emit LandVerified(_id, msg.sender);
    }

    function getLandDetails(uint256 _id) external view returns (LandTitle memory) {
        return landTitles[_id];
    }

    function revokeSurveyor(address _surveyor) external onlyAdmin {
        verifiedSurveyors[_surveyor] = false;
    }

    function updateLandDetails(uint256 _id, string memory _newLocation, uint256 _newArea) external {
        require(landTitles[_id].owner == msg.sender, "Only the owner can update land details");
        landTitles[_id].location = _newLocation;
        landTitles[_id].area = _newArea;
    }
} 

