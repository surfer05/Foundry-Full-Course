// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(),5e18);
    }

    function testOwner() public{
        assertEq(fundMe.i_owner(),address(this));
    }

    function testPriceFeedVersionIsAccurate() public{
        uint version = fundMe.getVersion();
        assertEq(version,4);
    }

}