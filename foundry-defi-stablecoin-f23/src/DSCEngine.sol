// SPDX-License-Identifier: MIT

// Layout of Contracts:
// version
// imports
// interfaces, libraries, contracts
// errors
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

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/**
 * @title DSCEngine.sol
 * @author Surfer_05
 * The system is deisgned to be as minimal as possible, and have the tokens maintain a 1 token == $1 peg at all times.
 * This is a stablecoin with the properties:
 * - Exogenously Collateralized
 * - Dollar Pegged
 * - Algorithmically Stable
 *
 * It is similar to DAI if DAI had no governance, no fees, and was backed by only WETH and WBTC.
 *
 * @notice This contract is the core of the Decentralized Stablecoin system. It handles all the logic
 * for minting and redeeming DSC, as well as depositing and withdrawing collateral.
 * @notice This contract is based on the MakerDAO DSS system
 */

contract DSCEngine is ReentrancyGuard {
    ////////////////////
    //// Errors    ////
    //////////////////
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenLengthAndPriceFeedLengthMustBeSame();
    error DSCEngine__TokenNotAllowed(address token);
    error DSCEngine__TransferFailed();

    //////////////////// ////////
    //// State variables    ////
    ///////////////////////////
    mapping(address token => address priceFeeds) s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount))  s_collateralDeposited;
    DecentralizedStableCoin private immutable i_dsc;

    //////////////////// ////////
    //// Events             ////
    ///////////////////////////
    event CollateralDeposited(address indexed user, address indexed token, uint indexed amount);

    ////////////////////
    //// Modifiers    /
    //////////////////

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) revert DSCEngine__NeedsMoreThanZero();
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) revert DSCEngine__TokenNotAllowed(token);
        _;
    }

    /////////////////////////////
    //// Functions          ////
    ///////////////////////////
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        // USD Price feeds
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenLengthAndPriceFeedLengthMustBeSame();
        }

        // ETH/USD , MKR/USD , BTC/USD , etc.
        for (uint8 i = 0; i < tokenAddresses.length; ++i) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }

        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    function depositCollateralAndMintDsc() external {}

    /**
     *
     * @param tokenCollateralAddress The address of token to be deposited as collateral
     * @param amountCollateral  the amount of collateral to be deposited
     */

    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress,amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if(!success) revert DSCEngine__TransferFailed();
    }

    function redeemCollateral() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function redeemCollateralForDsc() external {}

    function getHealthFactor() external {}

    function mintDsc() external {}
}
