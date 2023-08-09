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

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";

pragma solidity ^0.8.17;

contract DeployRaffle is Script {
    function run() external returns (Raffle) {}
}
