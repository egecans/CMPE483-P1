// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyGovToken is ERC20 {

    uint MyGovTokenSupply;

    uint surveyCreationUSDFee =  5; //0.04 ethers in wei
    uint surveyCreationMyGovFee =  2; 
    uint projectCreationUSDFee =  50; //0.1 ethers in wei
    uint ProjectCreationMyGovFee = 5; // in MyGov TOKEN 

    // Constructor to initialize the token with a name and symbol
    constructor(uint tokensupply) ERC20("MyGov Token", "MYGOV") {
        
        // Mint initial supply to the contract deployer
        _mint(msg.sender, tokensupply * 10 ** decimals()); // Example: Mint 1,000 MYGOV tokens
    }

    struct Survey {
        string ipfsHash;
        address owner;
        uint deadline;
        uint numChoices;
        uint atMostChoice;
        uint numTaken;
        uint [] results;
    }

    struct User {
        address userAddress;
        uint usdStableCoinBalance;
    }

    struct ProjectProposal {
        address proposer;
        string ipfsHash;
        uint deadline;
        uint[] paymentAmounts;
        uint[] paySchedule;
        bool isFunded;
    }

    Survey[] public surveys;
    ProjectProposal[] public proposals;

    function isMember(address userAddress) public view returns(bool){
        return balanceOf(userAddress) > 0;
    }

    function getSurveyResults(uint surveyid) public view returns(uint numtaken, uint[] memory results) {
        numtaken = surveys[surveyid].numTaken;
        results = surveys[surveyid].results;
        return (numtaken, results);
    }

    function getSurveyInfo(uint surveyid) public view returns(string memory ipfshash, uint surveydeadline,uint numchoices, uint atmostchoice) {
        ipfshash = surveys[surveyid].ipfsHash;
        surveydeadline = surveys[surveyid].deadline;
        numchoices = surveys[surveyid].numChoices;
        atmostchoice = surveys[surveyid].atMostChoice;
        return (ipfshash, surveydeadline, numchoices, atmostchoice);
    } 

    function getSurveyOwner(uint surveyid) public view returns(address surveyowner) {
        surveyowner = surveys[surveyid].owner;
        return surveyowner;
    }

    function getIsProjectFunded(uint projectid) public view returns(bool funded) {
        funded = proposals[projectid].isFunded;
        return funded;
    }
    
    function getProjectOwner(uint projectid) public view returns(address projectowner) {
        projectowner = proposals[projectid].proposer;
        return projectowner;
    }

    function getProjectInfo(uint activityid) public view returns(string memory ipfshash, uint votedeadline, uint[] memory paymentamounts, uint[] memory payschedule) {
        ipfshash = proposals[activityid].ipfsHash;
        votedeadline = proposals[activityid].deadline;
        paymentamounts = proposals[activityid].paymentAmounts;
        payschedule = proposals[activityid].paySchedule;
        ipfshash = proposals[activityid].ipfsHash;
        return (ipfshash, votedeadline, paymentamounts, payschedule);
    }

    function getNoOfProjectProposals() public view returns(uint numproposals) {
        numproposals = proposals.length;
        return numproposals;
    }

    function getNoOfFundedProjects() public view returns(uint numfunded) {
        numfunded = 0;
        for (uint i = 0; i < proposals.length; i++) 
        {
            if (proposals[i].isFunded) {
                numfunded ++;
            }
        }
        return numfunded;
    }

    function getNoOfSurveys() public view returns(uint numsurveys) {
        numsurveys = surveys.length;
        return numsurveys;
    }









    
}

