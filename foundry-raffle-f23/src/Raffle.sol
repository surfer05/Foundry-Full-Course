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

/**
 * @title A sample Raffle Contract
 * @author Surfer
 * @notice This contract is for creating a sample Raffle
 * @dev Implements Chainlink VRFv2
 */

contract Raffle {
    error Raffle__NotEnoughEthSent();

    uint private immutable i_entranceFee; // do we want to update the entrance fee, not really, thus make it immutable

    constructor(uint entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        if (msg.value < i_entranceFee) {
            revert NotEnoughEthSent();
        }
    }

    function pickWinner() public {}

    /** Getter functions */

    function getEntranceFee() external view returns (uint) {
        return i_entranceFee;
    }
}
