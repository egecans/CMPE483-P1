// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./USDStableCoin.sol";

contract MyGovToken is ERC20 {

    uint surveyUSDFee =  5; 
    uint surveyMyGovFee =  2; 
    uint projectUSDFee =  50;
    uint projectMyGovFee = 5;
    uint numOfFundedProjects = 0;
    USDStableCoin usdStableCoinContract;
    uint numberOfMembers = 0;

    // Constructor to initialize the token with a name and symbol
    constructor(uint tokensupply, address usdStableCoinAddress) ERC20("MyGov Token", "MYGOV") {

        usdStableCoinContract = USDStableCoin(usdStableCoinAddress);
        
        // Mint initial supply to the contract deployer
        _mint(address(this), tokensupply); // Example: Mint 1,000 MYGOV tokens
    }

    struct Survey {
        string ipfsHash;
        address owner;
        uint deadline;
        uint numChoices;
        uint atMostChoice;
        uint numTaken;
        uint [] results;
        mapping(address => bool) participants;  

    }

    struct User {
        address userAddress;
        uint usdStableCoinBalance;
        bool fauceted;
    }

    struct ProjectProposal {
        address projectOwner;
        string ipfsHash;
        uint deadline;
        uint[] paymentAmounts;
        uint[] paySchedule;
        bool isFunded;
        mapping(address => bool) voters;
        uint vote; 
    }

    Survey[] public surveys;
    ProjectProposal[] public proposals;
    mapping(address => User) public users;  

    function donateMyGovToken(uint amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient amount of MyGovToken");
        transfer(address(this), amount);
        if (balanceOf(msg.sender) == 0 && numberOfMembers > 0){
            numberOfMembers --;
        }
    }

    function donateUSD(uint amount) public {
        require(usdStableCoinContract.balanceOf(msg.sender) >= amount, 'Insufficient amount of USD Stable Coin');
        usdStableCoinContract.transferFrom(msg.sender, address(usdStableCoinContract), amount);
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
        projectowner = proposals[projectid].projectOwner;
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
        numfunded = numOfFundedProjects;
        return numfunded;
    }

    function getNoOfSurveys() public view returns(uint numsurveys) {
        numsurveys = surveys.length;
        return numsurveys;
    }

    function faucet() public {
        require(users[msg.sender].fauceted == false, "User got already the faucet.");        
        this.transfer(msg.sender, 1);
        users[msg.sender].fauceted = true;
        numberOfMembers ++;
    }

    function submitSurvey(string memory ipfshash,uint surveydeadline,uint numchoices, uint atmostchoice) public returns (uint surveyid) {
        require(balanceOf(msg.sender) > 0, "Users must be member to submit survey.");
        require(balanceOf(msg.sender) >= surveyMyGovFee, "There isn't enough amount of MyGovToken to submit survey.");
        require(usdStableCoinContract.balanceOf(msg.sender) >= surveyUSDFee, "There isn't enough amount of USD to submit survey.");
        transfer(address(this), surveyMyGovFee);
        usdStableCoinContract.transferFrom(msg.sender, address(usdStableCoinContract), surveyUSDFee);
        surveyid = surveys.length;
        Survey storage survey = surveys[surveyid];
        survey.ipfsHash = ipfshash;
        survey.deadline = surveydeadline;
        survey.numChoices = numchoices;
        survey.atMostChoice = atmostchoice;
        survey.owner = msg.sender;
        survey.numTaken = 0;
        for (uint i = 0; i < numchoices; i++) 
        {
            survey.results[i] = 0;
        }
        if (balanceOf(msg.sender) == 0) {
            numberOfMembers --;
        }

        return surveyid;
    }

    function takeSurvey(uint surveyid, uint [] memory choices) public {
        Survey storage _survey = surveys[surveyid];
        require(balanceOf(msg.sender) > 0, "Users must be member to take survey.");
        require(_survey.deadline < block.timestamp, "Deadline is passed.");
        require(_survey.participants[msg.sender] == false, "User has already taken the survey.");
        require(_survey.atMostChoice >= choices.length, "User chose too much option.");
        for (uint i = 0; i < choices.length; i ++) {
            uint choice = choices[i];
            _survey.results[choice] ++;
        }
        _survey.numTaken ++;
        _survey.participants[msg.sender] = true;
    }

    function submitProjectProposal(string memory ipfshash, uint votedeadline, uint [] memory paymentamounts, uint [] memory payschedule) public returns (uint projectid) {
        require(balanceOf(msg.sender) > 0, "Users must be member to submit survey.");
        require(balanceOf(msg.sender) >= projectMyGovFee, "There isn't enough amount of MyGovToken to propose project.");
        require(usdStableCoinContract.balanceOf(msg.sender) >= projectUSDFee, "There isn't enough amount of USD to propose project.");
        transfer(address(this), projectMyGovFee);
        usdStableCoinContract.transferFrom(msg.sender, address(usdStableCoinContract), projectUSDFee);
        projectid = proposals.length;
        ProjectProposal storage project = proposals[projectid];
        project.ipfsHash = ipfshash;
        project.deadline = votedeadline;
        project.isFunded = false;
        project.paymentAmounts = paymentamounts;
        project.paySchedule = payschedule;
        project.projectOwner = msg.sender;

        if (balanceOf(msg.sender) == 0) {
            numberOfMembers --;
        }

        return projectid;
    }

    //function reserveProjectGrant(uint projectid) public {
    //    ProjectProposal storage project = proposals[projectid];
    //    require(project.isFunded, "Project must be funded.");
    //    require(msg.sender == project.projectOwner, "User is not the project owner.");
    //    require(project.deadline < block.timestamp, "Deadline is passed.");
    //}
    
}

