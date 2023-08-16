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

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/**
 * @title A sample Raffle Contract
 * @author Surfer
 * @notice This contract is for creating a sample Raffle
 * @dev Implements Chainlink VRFv2
 */

contract Raffle is VRFConsumerBaseV2 {
    error Raffle__NotEnoughEthSent();
    error Raffle__TransferFailed();
    error Raffle__RaffleNotOpen();
    error Raffle__UpKeepNotNeeded(uint256, uint256, uint256);

    /**
     * Type Declarations
     */
    enum RaffleState {
        OPEN,
        CALCULATING
    }

    /**
     * State variables
     */
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee; // do we want to update the entrance fee, not really, thus make it immutable
    uint256 private immutable i_interval;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    uint256 private s_lastTimestamp;
    // @dev duration of the lottery in seconds
    address payable[] private s_players;
    address private s_recentWinner;
    RaffleState private s_raffleState;

    /**
     * Events
     */
    event EnteredRaffle(address indexed player);
    event PickedWinner(address indexed winner);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        s_lastTimestamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
    }

    function enterRaffle() public payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        if (s_raffleState != RaffleState.OPEN) revert Raffle__RaffleNotOpen();
        s_players.push(payable(msg.sender));

        // Makes migration easier
        emit EnteredRaffle(msg.sender);
    }

    function fulfillRandomWords(uint256, /*requestId*/ uint256[] memory randomWords) internal override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;
        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0);
        s_lastTimestamp = block.timestamp;
        (bool success,) = winner.call{value: address(this).balance}("");
        if (!success) revert Raffle__TransferFailed();
        emit PickedWinner(winner);
    }

    // When is the winner supposed to be picked
    /**
     * @dev This is the functions that Chainlink Automation nodes call to see if it's time to perform an Upkeep
     * The following should be true for this to return true:
     * 1. The time interval has passed between raffle runs
     * 2. The Raffle is in the OPEN state
     * 3. The contract has ETH, aka has players
     * 4. Implicit - the subscription is funded with LINK.
     * @return upKeepNeeded
     * @return
     */

    function checkUpKepp(bytes memory /*checkData*/ )
        public
        view
        returns (bool upKeepNeeded, bytes memory /* perfromData */ )
    {
        bool timeHasPassed = (block.timestamp - s_lastTimestamp) >= i_interval;
        bool isOpen = RaffleState.OPEN == s_raffleState;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;
        upKeepNeeded = (timeHasPassed && isOpen && hasBalance && hasPlayers);
        return (upKeepNeeded, "0x0");
    }

    // Get a random number
    // Use the random number to pick a player
    // Be automatically called
    function performUpKeep(bytes calldata /* performData */ ) public {
        (bool upkeepNeeded,) = checkUpKepp("");
        if (!upkeepNeeded) {
            revert Raffle__UpKeepNotNeeded(address(this).balance, s_players.length, uint256(s_raffleState));
        }

        if (block.timestamp - s_lastTimestamp < i_interval) {
            revert();
        }
        s_raffleState = RaffleState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, i_subscriptionId, REQUEST_CONFIRMATIONS, i_callbackGasLimit, NUM_WORDS
        );
    }

    /**
     * Getter functions
     */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() external view returns(RaffleState){
        return s_raffleState;
    }
}
