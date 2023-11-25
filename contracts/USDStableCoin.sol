// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract USDStableCoin is ERC20, Ownable {
    // Address of the MyGov contract (assuming you have MyGov contract deployed)
    address public myGovContract;

    // Event triggered when MyGov contract grants USD stable coins
    event GrantUSD(address indexed recipient, uint256 amount);

    constructor() ERC20("USD Stable Coin", "USDS") {
        _mint(msg.sender, 1000000 * 10**18); // Mint initial supply (1,000,000 USDS)
    }

    // Function to set the MyGov contract address (onlyOwner)
    function setMyGovContract(address _myGovContract) external onlyOwner {
        myGovContract = _myGovContract;
    }

    // Function to grant USD stable coins to an address (called by MyGov contract)
    function grantUSD(address recipient, uint256 amount) external {
        require(msg.sender == myGovContract, "Caller is not the MyGov contract");
        _mint(recipient, amount);
        emit GrantUSD(recipient, amount);
    }

    // Function to burn USD stable coins (e.g., for redemption)
    function burnUSD(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn");
        _burn(msg.sender, amount);
    }
}
