import { ethers } from "./ethers-5.6.esm.min.js";
import { myGovTokenAbi, myGovTokenContractAddress, usdStableCoinAbi, usdStableCoinContractAddress } from "./constants.js";

const loadingSpinner = document.getElementById("loadingSpinner");

// Connect Button
const connectButton = document.getElementById("connectButton");

// Get Balance Button
const balanceButton = document.getElementById("balanceButton");

// Donate MyGovToken
const donateMyGovTokenAmount = document.getElementById("donateMyGovTokenAmount");
const donateMyGovTokenButton = document.getElementById("donateMyGovTokenButton");

// Donate USD Stable Coins
const donateUSDAmount = document.getElementById("donateUSDAmount");
const donateUSDButton = document.getElementById("donateUSDButton");

// Get Survey Information
const surveyId = document.getElementById("surveyId");
const getSurveyInfoButton = document.getElementById("getSurveyInfoButton");

// Get Survey Owner
const surveyOwnerSurveyId = document.getElementById("surveyOwnerSurveyId");
const getSurveyOwnerButton = document.getElementById("getSurveyOwnerButton");

// Get Is Project Funded
const projectFundedId = document.getElementById("projectFundedId");
const getIsProjectFundedButton = document.getElementById("getIsProjectFundedButton");

// Get Project Next Payment
const projectNextPaymentId = document.getElementById("projectNextPaymentId");
const getProjectNextPaymentButton = document.getElementById("getProjectNextPaymentButton");

// Get Project Owner
const projectOwnerProjectId = document.getElementById("projectOwnerProjectId");
const getProjectOwnerButton = document.getElementById("getProjectOwnerButton");

// Get Project Info
const projectInfoId = document.getElementById("projectInfoId");
const getProjectInfoButton = document.getElementById("getProjectInfoButton");

// Get Number of Project Proposals
const getNoOfProjectProposalsButton = document.getElementById("getNoOfProjectProposalsButton");

// Get Number of Funded Projects
const getNoOfFundedProjectsButton = document.getElementById("getNoOfFundedProjectsButton");

// Get USD Received by Project
const usdReceivedProjectId = document.getElementById("usdReceivedProjectId");
const getUSDReceivedByProjectButton = document.getElementById("getUSDReceivedByProjectButton");

// Get Number of Surveys
const getNoOfSurveysButton = document.getElementById("getNoOfSurveysButton");

// Faucet
const myGovTokenFaucetButton = document.getElementById("myGovTokenFaucetButton");

// Faucet
const usdStableCoinFaucetButton = document.getElementById("usdStableCoinFaucetButton");

// Submit Survey
const submitSurveyIpfs = document.getElementById("submitSurveyIpfs");
const submitSurveyDeadline = document.getElementById("submitSurveyDeadline");
const submitSurveyNumChoices = document.getElementById("submitSurveyNumChoices");
const submitSurveyAtMostChoice = document.getElementById("submitSurveyAtMostChoice");
const submitSurveyButton = document.getElementById("submitSurveyButton");

// Take Survey
const takeSurveyId = document.getElementById("takeSurveyId");
const takeSurveyChoices = document.getElementById("takeSurveyChoices");
const takeSurveyButton = document.getElementById("takeSurveyButton");

// Submit Project Proposal
const submitProjectIpfs = document.getElementById("submitProjectIpfs");
const submitProjectDeadline = document.getElementById("submitProjectDeadline");
const submitProjectAmounts = document.getElementById("submitProjectAmounts");
const submitProjectSchedule = document.getElementById("submitProjectSchedule");
const submitProjectProposalButton = document.getElementById("submitProjectProposalButton");

// Reserve Project Grant
const reserveGrantProjectId = document.getElementById("reserveGrantProjectId");
const reserveProjectGrantButton = document.getElementById("reserveProjectGrantButton");

// Withdraw Project Payment
const withdrawPaymentProjectId = document.getElementById("withdrawPaymentProjectId");
const withdrawProjectPaymentButton = document.getElementById("withdrawProjectPaymentButton");

// Delegate Vote
const delegateVoteMemberAddress = document.getElementById("delegateVoteMemberAddress");
const delegateVoteProjectId = document.getElementById("delegateVoteProjectId");
const delegateVoteToButton = document.getElementById("delegateVoteToButton");

// Vote for Project Proposal
const voteForProjectId = document.getElementById("voteForProjectId");
const voteForProjectChoice = document.getElementById("voteForProjectChoice");
const voteForProjectProposalButton = document.getElementById("voteForProjectProposalButton");

// Vote for Project Payment
const voteForPaymentProjectId = document.getElementById("voteForPaymentProjectId");
const voteForPaymentChoice = document.getElementById("voteForPaymentChoice");
const voteForProjectPaymentButton = document.getElementById("voteForProjectPaymentButton");

//=================================================================================================================================================================
// Connect Button
connectButton.onclick = connect;

// Get Balance Button
balanceButton.onclick = getBalance;

// Donate MyGovToken
donateMyGovTokenButton.onclick = () => {
   const amount = parseFloat(donateMyGovTokenAmount.value);
   donateMyGovToken(amount);
};

// Donate USD Stable Coins
donateUSDButton.onclick = () => {
   const amount = parseInt(donateUSDAmount.value);
   donateUSD(amount);
};

// Get Survey Information
getSurveyInfoButton.onclick = () => {
   const id = parseInt(surveyId.value);
   getSurveyInfo(id);
};

// Get Survey Owner
getSurveyOwnerButton.onclick = () => {
   const id = parseInt(surveyOwnerSurveyId.value);
   getSurveyOwner(id);
};

// Get Is Project Funded
getIsProjectFundedButton.onclick = () => {
   const id = parseInt(projectFundedId.value);
   getIsProjectFunded(id);
};

// Get Project Next Payment
getProjectNextPaymentButton.onclick = () => {
   const id = parseInt(projectNextPaymentId.value);
   getProjectNextPayment(id);
};

// Get Project Owner
getProjectOwnerButton.onclick = () => {
   const id = parseInt(projectOwnerProjectId.value);
   getProjectOwner(id);
};

// Get Project Info
getProjectInfoButton.onclick = () => {
   const id = parseInt(projectInfoId.value);
   getProjectInfo(id);
};

// Get Number of Project Proposals
getNoOfProjectProposalsButton.onclick = getNoOfProjectProposals;

// Get Number of Funded Projects
getNoOfFundedProjectsButton.onclick = getNoOfFundedProjects;

// Get USD Received by Project
getUSDReceivedByProjectButton.onclick = () => {
   const id = parseInt(usdReceivedProjectId.value);
   getUSDReceivedByProject(id);
};

// Get Number of Surveys
getNoOfSurveysButton.onclick = getNoOfSurveys;

// Faucet
myGovTokenFaucetButton.onclick = myGovTokenFaucet;

// Faucet
usdStableCoinFaucetButton.onclick = usdStableCoinFaucet;

// Submit Survey
submitSurveyButton.onclick = () => {
   const ipfsHash = submitSurveyIpfs.value;
   const deadline = parseInt(submitSurveyDeadline.value);
   const numChoices = parseInt(submitSurveyNumChoices.value);
   const atMostChoice = parseInt(submitSurveyAtMostChoice.value);
   submitSurvey(ipfsHash, deadline, numChoices, atMostChoice);
};

// Take Survey
takeSurveyButton.onclick = () => {
   const id = parseInt(takeSurveyId.value);
   const choices = takeSurveyChoices.value.split(",").map((choice) => choice.trim());
   takeSurvey(id, choices);
};

// Submit Project Proposal
submitProjectProposalButton.onclick = () => {
   const ipfsHash = submitProjectIpfs.value;
   const deadline = parseInt(submitProjectDeadline.value);
   const amounts = submitProjectAmounts.value.split(",").map((amount) => parseInt(amount.trim()));
   const schedule = submitProjectSchedule.value.split(",").map((time) => parseInt(time.trim()));
   submitProjectProposal(ipfsHash, deadline, amounts, schedule);
};

// Reserve Project Grant
reserveProjectGrantButton.onclick = () => {
   const id = parseInt(reserveGrantProjectId.value);
   reserveProjectGrant(id);
};

// Withdraw Project Payment
withdrawProjectPaymentButton.onclick = () => {
   const id = parseInt(withdrawPaymentProjectId.value);
   withdrawProjectPayment(id);
};

// Delegate Vote
delegateVoteToButton.onclick = () => {
   const memberAddress = delegateVoteMemberAddress.value;
   const projectId = parseInt(delegateVoteProjectId.value);
   delegateVoteTo(memberAddress, projectId);
};

// Vote for Project Proposal
voteForProjectProposalButton.onclick = () => {
   const id = parseInt(voteForProjectId.value);
   const choice = voteForProjectChoice.value.toLowerCase() === "true";
   voteForProjectProposal(id, choice);
};

// Vote for Project Payment
voteForProjectPaymentButton.onclick = () => {
   const id = parseInt(voteForPaymentProjectId.value);
   const choice = voteForPaymentChoice.value.toLowerCase() === "true";
   voteForProjectPayment(id, choice);
};
//=================================================================================================================================================================
const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner(); // how we are getting the account from the metamask
const myGovTokenContract = new ethers.Contract(myGovTokenContractAddress, myGovTokenAbi, signer);
const usdStableCoinContract = new ethers.Contract(usdStableCoinContractAddress, usdStableCoinAbi, signer);

async function connect() {
   // to account
   if (typeof window.ethereum !== "ethereum") {
      try {
         await window.ethereum.request({ method: "eth_requestAccounts" });
      } catch (er) {
         console.log(er);
      }
      connectButton.innerHTML = "CONNECTED!!!";
      const accounts = await window.ethereum.request({
         method: "eth_accounts",
      });
      console.log(accounts);
   }
}
async function getBalance() {
   // balance of the contract
   if (typeof window.ethereum !== "undefined") {
      const provider = new ethers.providers.Web3Provider(window.ethereum); // ethers know that this is a wallet, and it will call the RPC inside the network
      const balance = await provider.getBalance(myGovTokenContractAddress);
      console.log(balance.toString());
   }
}

async function donateMyGovToken(amount) {
   try {
      // Assuming 'contract' is your instantiated ethers.js contract
      const tx = await myGovTokenContract.donateMyGovToken(amount);

      // Wait for the transaction to be mined
      const receipt = await tx.wait();

      console.log("Donation successful. Transaction receipt:", receipt);
   } catch (error) {
      console.error("Error donating MyGov tokens:", error);
   }
}

async function donateUSD(amount) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      // Assuming 'usdStableCoinContract' is your instantiated USD Stable Coin contract
      const gasLimit = 200000;
      const tx = await myGovTokenContract.donateUSD(amount, { gasLimit });

      // Wait for the transaction to be mined
      const receipt = await tx.wait();

      console.log("Donation successful. Transaction receipt:", receipt);
   } catch (error) {
      console.error("Error donating USD Stable Coins:", error);
   }
}

async function getSurveyInfo(surveyId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getSurveyInfo(surveyId);

      // The result will be an array with the values returned by the function
      const [ipfshash, surveydeadline, numchoices, atmostchoice] = result;

      console.log("Survey Information:");
      console.log("IPFS Hash:", ipfshash);
      console.log("Survey Deadline:", surveydeadline);
      console.log("Number of Choices:", numchoices);
      console.log("At Most Choice:", atmostchoice);
   } catch (error) {
      console.error("Error getting survey information:", error);
   }
}

async function getSurveyOwner(surveyId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getSurveyOwner(surveyId);

      console.log("Survey Owner:", result);
   } catch (error) {
      console.error("Error getting survey owner:", error);
   }
}

async function getIsProjectFunded(projectId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getIsProjectFunded(projectId);

      console.log("Is Project Funded:", result);
   } catch (error) {
      console.error("Error checking if the project is funded:", error);
   }
}

async function getProjectNextPayment(projectId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getProjectNextPayment(projectId);

      console.log("Next Payment Amount:", result);
   } catch (error) {
      console.error("Error getting the next payment amount for the project:", error);
   }
}

async function getProjectOwner(projectId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getProjectOwner(projectId);

      console.log("Project Owner:", result);
   } catch (error) {
      console.error("Error getting the project owner:", error);
   }
}

async function getProjectInfo(activityId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getProjectInfo(activityId);

      // The result will be an array with the values returned by the function
      const [ipfshash, votedeadline, paymentamounts, payschedule] = result;

      console.log("Project Information:");
      console.log("IPFS Hash:", ipfshash);
      console.log("Vote Deadline:", votedeadline);
      console.log("Payment Amounts:", paymentamounts);
      console.log("Pay Schedule:", payschedule);
   } catch (error) {
      console.error("Error getting project information:", error);
   }
}

async function getNoOfProjectProposals() {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getNoOfProjectProposals();

      console.log("Number of Project Proposals:", result);
   } catch (error) {
      console.error("Error getting the number of project proposals:", error);
   }
}

async function getNoOfFundedProjects() {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getNoOfFundedProjects();

      console.log("Number of Funded Projects:", result);
   } catch (error) {
      console.error("Error getting the number of funded projects:", error);
   }
}

async function getUSDReceivedByProject(projectId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getUSDReceivedByProject(projectId);

      console.log("USD Received by Project:", result);
   } catch (error) {
      console.error("Error getting USD received by the project:", error);
   }
}

async function getNoOfSurveys() {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const result = await myGovTokenContract.getNoOfSurveys();

      console.log("Number of Surveys:", result);
   } catch (error) {
      console.error("Error getting the number of surveys:", error);
   }
}

async function myGovTokenFaucet() {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const faucetTx = await myGovTokenContract.faucet();

      // Wait for the transaction to be mined
      const receipt = await faucetTx.wait();

      console.log("Faucet successful. Transaction receipt:", receipt);
   } catch (error) {
      console.log(`Error while using the faucet:${error.message}`);
   }
}

async function submitSurvey(ipfshash, surveydeadline, numchoices, atmostchoice) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const submitSurveyTx = await myGovTokenContract.submitSurvey(ipfshash, surveydeadline, numchoices, atmostchoice);

      // Wait for the transaction to be mined
      const receipt = await submitSurveyTx.wait();

      console.log("Survey submitted successfully. Transaction receipt:", receipt);
   } catch (error) {
      console.error("Error submitting survey:", error);
   }
}

async function takeSurvey(surveyId, choices) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const takeSurveyTx = await myGovTokenContract.takeSurvey(surveyId, choices);

      // Wait for the transaction to be mined
      const receipt = await takeSurveyTx.wait();

      console.log("Survey taken successfully. Transaction receipt:", receipt);
   } catch (error) {
      console.error("Error taking the survey:", error);
   }
}

async function submitProjectProposal(ipfshash, votedeadline, paymentamounts, payschedule) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const submitProjectTx = await myGovTokenContract.submitProjectProposal(ipfshash, votedeadline, paymentamounts, payschedule);

      // Wait for the transaction to be mined
      const receipt = await submitProjectTx.wait();

      console.log("Project proposal submitted successfully. Transaction receipt:", receipt);
   } catch (error) {
      console.error("Error submitting project proposal:", error);
   }
}

async function reserveProjectGrant(projectId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const reserveGrantTx = await myGovTokenContract.reserveProjectGrant(projectId);

      // Wait for the transaction to be mined
      const receipt = await reserveGrantTx.wait();

      // Update reservedUSD and numOfFundedProjects
      console.log("Project grant reserved successfully.", receipt);
   } catch (error) {
      console.error("Error reserving project grant:", error);
   }
}

async function withdrawProjectPayment(projectId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const withdrawPaymentTx = await myGovTokenContract.withdrawProjectPayment(projectId);

      // Wait for the transaction to be mined
      const receipt = await withdrawPaymentTx.wait();

      // Update reservedUSD and project status if needed
      console.log("Project payment withdrawn successfully.", receipt);
   } catch (error) {
      console.error("Error withdrawing project payment:", error);
   }
}

async function delegateVoteTo(memberAddress, projectId) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const delegateVoteTx = await myGovTokenContract.delegateVoteTo(memberAddress, projectId);

      // Wait for the transaction to be mined
      await delegateVoteTx.wait();

      console.log("Vote delegated successfully.");
   } catch (error) {
      console.error("Error delegating vote:", error);
   }
}

async function voteForProjectProposal(projectId, choice) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const voteForProjectTx = await myGovTokenContract.voteForProjectProposal(projectId, choice);

      // Wait for the transaction to be mined
      await voteForProjectTx.wait();

      console.log("Vote for project proposal submitted successfully.");
   } catch (error) {
      console.error("Error voting for project proposal:", error);
   }
}

async function voteForProjectPayment(projectId, choice) {
   try {
      // Assuming 'myGovTokenContract' is your instantiated ethers.js contract for MyGovToken
      const voteForPaymentTx = await myGovTokenContract.voteForProjectPayment(projectId, choice);

      // Wait for the transaction to be mined
      await voteForPaymentTx.wait();

      console.log("Vote for project payment submitted successfully.");
   } catch (error) {
      console.error("Error voting for project payment:", error);
   }
}

async function usdStableCoinFaucet() {
   try {
      const transaction = await usdStableCoinContract.faucet();
      const receipt = await transaction.wait();
      console.log(`Successfully obtained USDStableCoin. Receipt: ${receipt}`);
   } catch (error) {
      console.log(`An error occurred during usdStableCoinFaucet: ${error}`);
   }
}

// Function to transfer USD
async function transferFromUSD(receiver, amount) {
   try {
      // Call the transferFromUSD function on the contract
      const transaction = await usdStableCoinContract.transferFromUSD(receiver, amount);

      // Wait for the transaction to be mined
      await transaction.wait();

      console.log(`Transfer successful! ${amount} USD sent to ${receiver}`);
   } catch (error) {
      console.error("Error:", error.message);
   }
}
