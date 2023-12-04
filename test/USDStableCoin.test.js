const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("USDStableCoin", function () {
  it("Should deploy USDStableCoin and perform tests", async function () {
    const USDStableCoin = await ethers.getContractFactory("USDStableCoin");
    const usdStableCoin = await USDStableCoin.deploy();

    // Retrieve total supply as a string
    const totalSupply = (await usdStableCoin.totalSupply()).toString();

    // Perform the assertion
    expect(totalSupply).to.equal("10000");
  });
});
