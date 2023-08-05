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

    /** State variables */
    uint private immutable i_entranceFee; // do we want to update the entrance fee, not really, thus make it immutable
    address payable[] private s_players;

    /** Events */
    event EnteredRaffle(address indexed player);

    constructor(uint entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    function pickWinner() public {}

    /** Getter functions */

    function getEntranceFee() external view returns (uint) {
        return i_entranceFee;
    }
}