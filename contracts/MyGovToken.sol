// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
    uint reservedUSD = 0;

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
        bool fauceted;
        mapping(uint => address) delegation;
        uint lockedUntil;
        mapping(uint => uint) weight;
    }

    struct ProjectProposal {
        address projectOwner;
        string ipfsHash;
        uint deadline;
        uint[] paymentAmounts;
        uint[] paySchedule;
        bool isFunded;
        mapping(address => bool) voters;
        mapping(address => bool) paymentvoters;
        uint vote; 
        uint votepayment;
        bool[] withdrawed;
        

    }

    Survey[] public surveys;
    ProjectProposal[] public proposals;
    mapping(address => User) public users;  

    function donateMyGovToken(uint amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient amount of MyGovToken");
        transfer(address(this), amount);
        if (balanceOf(msg.sender) == 0) {
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

    function getProjectNextPayment(uint projectid) public view returns(int next) {
        ProjectProposal storage project = proposals[projectid];
        for (uint i = 0; i < project.paySchedule.length; i++) 
        {
            if (block.timestamp < project.paySchedule[i]) {
                next = int(project.paymentAmounts[i]);
                break;
            }
        }
        return next;

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

    function getUSDReceivedByProject (uint projectid) public view returns(uint amount) {
        amount = 0;
        ProjectProposal storage project = proposals[projectid];
        for (uint i = 0; i < project.paymentAmounts.length; i++) 
        {
            if (project.withdrawed[i] == false) {
                break;
            }
            amount += project.paymentAmounts[i];
        }
        return amount;
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
        project.vote = 0;
        project.votepayment = 0;

        if (balanceOf(msg.sender) == 0) {
            numberOfMembers --;
        }
        for (uint i = 0; i < project.paymentAmounts.length; i++) 
        {
            project.withdrawed[i] = false;
        }
        return projectid;
    }

    function reserveProjectGrant(uint projectid) public {
        ProjectProposal storage project = proposals[projectid];
        require(msg.sender == project.projectOwner, "User is not the project owner.");
        require(project.deadline < block.timestamp, "Deadline is passed.");
        require(project.vote >= numberOfMembers/10, "Insufficient vote");
        uint funding = 0;
        
        for (uint i = 0; i < project.paymentAmounts.length; i ++) 
        {
            funding += project.paymentAmounts[i];
        }

        require(usdStableCoinContract.balanceOf(address(usdStableCoinContract)) >= funding + reservedUSD, "Insufficient amount of USD to grant");
        reservedUSD += funding;
        project.isFunded = true;
        numOfFundedProjects ++;
    }

    function withdrawProjectPayment(uint projectid) public {
        ProjectProposal storage project = proposals[projectid];
        require(project.isFunded, "Project must be funded.");
        require(msg.sender == project.projectOwner, "User is not the project owner.");
        if (project.votepayment >= numberOfMembers/100) {
            for (uint i = 0; i < project.paySchedule.length; i++) 
            {
                if (project.withdrawed[i] == false && project.paySchedule[i] < block.timestamp) {
                require(project.paymentAmounts[i] < reservedUSD, "Insufficient reserved.");
                usdStableCoinContract.transferFrom(address(usdStableCoinContract), msg.sender, project.paymentAmounts[i]);
                reservedUSD -= project.paymentAmounts[i];
                project.withdrawed[i] = true;
                }
            }
        } else {
            project.isFunded = false;
        }
        
    }

    function delegateVoteTo(address memberaddr,uint projectid) public {
        ProjectProposal storage project = proposals[projectid];
        User storage user = users[msg.sender];
        User storage delegate = users[memberaddr];
        require(project.voters[msg.sender] == false, "User already voted.");
        require(project.voters[memberaddr] == false, "Delegated user already voted.");
        require(msg.sender != memberaddr, "Self delegation is not allowed.");
        require(balanceOf(msg.sender) > 0, "User must be a member.");
        require(balanceOf(memberaddr) > 0, "Delegate must be a member.");
        require(user.delegation[projectid] == address(0), "User already delegated his/her vote.");
        require(delegate.delegation[projectid] == address(0), "Delegate already delegated his/her vote.");
        user.delegation[projectid] = memberaddr;
        if (delegate.weight[projectid] == 0 || delegate.weight[projectid] == 1) {
            delegate.weight[projectid] = 2;
        } else {
            delegate.weight[projectid] ++;
        }
        user.lockedUntil = project.deadline;
    }

    function voteForProjectProposal(uint projectid,bool choice) public {
        require(balanceOf(msg.sender) > 0, "Voter must be a member.");
        ProjectProposal storage project = proposals[projectid];
        User storage user = users[msg.sender];
        require(project.voters[msg.sender] == false, "User already voted.");
        require(user.delegation[projectid] == address(0), "User already delegated his/her vote.");
        require(block.timestamp > user.lockedUntil, "User's vote is locked until deadline of another project.");
        require(block.timestamp < project.deadline, "Deadline of the proposal is passed.");
        if (choice == true) {
            project.vote += user.weight[projectid];
        }
        project.voters[msg.sender] = true;
    }

    function voteForProjectPayment(uint projectid,bool choice) public {
        require(balanceOf(msg.sender) > 0, "Voter must be a member.");
        ProjectProposal storage project = proposals[projectid];
        User storage user = users[msg.sender];
        require(project.paymentvoters[msg.sender] == false, "User already voted.");
        require(user.delegation[projectid] == address(0), "User already delegated his/her vote.");
        require(block.timestamp > user.lockedUntil, "User's vote is locked until deadline of another project.");
        require(block.timestamp < project.deadline, "Deadline of the proposal is passed.");
        if (choice == true) {
            project.votepayment += user.weight[projectid];
        }
        project.paymentvoters[msg.sender] = true;
    }


}

