// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {RequestPrice} from "../src/RequestPrice.sol";

contract DeployRequestPrice is Script {
    function run() external returns (RequestPrice) {
        vm.startBroadcast();
        RequestPrice requestPrice = new RequestPrice();
        vm.stopBroadcast();
        return requestPrice;
    }
}
