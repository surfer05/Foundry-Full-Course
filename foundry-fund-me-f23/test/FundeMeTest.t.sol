// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = address(1);
    uint public constant SEND_VALUE = 0.1 ether;
    uint public constant NEW_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, NEW_BALANCE);
    }

    modifier funded() {
        vm.startPrank(USER);
        fundMe.fund{value: SEND_VALUE}();
        vm.stopPrank();
        _;
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(),5e18);
    }


    function testPriceFeedVersionIsAccurate() public{
        uint version = fundMe.getVersion();
        assertEq(version,4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // Next line must fail for the test to be successful
        fundMe.fund();  // sending 0 value, thus it will fail and therefore test will pass
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.startPrank(USER);
        fundMe.fund{value: SEND_VALUE}();
        vm.stopPrank();
        address funder = fundMe.getFunders(0);
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded,SEND_VALUE);
        assertEq(funder,USER);

    }

    function testOnlyOwnerCanWithdraw() public funded{

        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public {
        // Arrange
        uint startingOwnerBalance = fundMe.getOwner().balance;
        uint startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        uint endingOwnerBalance = fundMe.getOwner().balance;
        uint endingFundMeBalance = address(fundMe).balance;

        assertEq(endingOwnerBalance,startingOwnerBalance + startingFundMeBalance);
        assertEq(endingFundMeBalance,0);
    }


}
