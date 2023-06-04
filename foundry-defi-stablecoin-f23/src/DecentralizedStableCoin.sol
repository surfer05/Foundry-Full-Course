// SPDX-License-Identifier: MIT

// Layout of Contracts:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type Declaration
// State Variables
// Events
// Modifiers
// Functions

// Layout of functions 
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public 
// internal
// private
// view & pure functions

pragma solidity ^0.8.18;
import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/**
 * @title DecentralizedStableCoin
 * @author Patrick Collins
 * Collateral: Exogenous (ETH & BTC)
 * Minting: Algorithmic
 * Relative Stability : Pegged to USD
 * This is the contract meant to be governed by DSCEngine. This contract is just the ERC20 implementation of our stablecoin system.
 *  
 */

contract DecentralizedStableCoin {

}
