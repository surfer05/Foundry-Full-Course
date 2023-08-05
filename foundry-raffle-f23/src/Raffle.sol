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
    uint256 private constant REQUEST_CONFIRMATIONS = 3;
    uint private constant NUM_WORDS = 1;

    uint private immutable i_entranceFee; // do we want to update the entrance fee, not really, thus make it immutable
    uint private immutable i_interval;
    address private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    uint private s_lastTimestamp;
    // @dev duration of the lottery in seconds
    address payable[] private s_players;


    /** Events */
    event EnteredRaffle(address indexed player);

    constructor(uint entranceFee, uint interval, address vrfCoordinator, bytes32 gasLane, uint64 subscriptionId, uint32 callbackGasLimit) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_vrfCoordinator = vrfCoordinator;
        s_lastTimestamp = block.timestamp;
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() public payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));

        // Makes migration easier
        emit EnteredRaffle(msg.sender);
    }

    // Get a random number
    // Use the random number to pick a player
    // Be automatically called
    function pickWinner() public {
        if(block.timestamp - s_lastTimestamp < i_interval){
            revert();
        }

        uint requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );1
    }

    /** Getter functions */

    function getEntranceFee() external view returns (uint) {
        return i_entranceFee;
    }
}
