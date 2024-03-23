// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title Price Guess
 * @author Tim Ou (GT)
 * @notice A Price Guess Contract
 * @dev Implements Chainlink Data Feed & Automation
 */

contract PriceGuess {
    /** Errors */
    error PriceGuess__NotEnoughETHSent();
    error PriceGuess__NotOpen();
    error PriceGuess__UpkeepNotNeeded();

    /** Enums */
    enum PriceGuessState {
        OPEN,
        SETTLING
    }

    /** State Varibles */
    uint256 constant ENTRANCE_FEE = 0.01 ether;
    uint256 constant INTERVAL = 12 hours;

    address payable[] private s_bullGuessors;
    address payable[] private s_bearGuessors;
    uint256 private s_bullGuessorBalance;
    uint256 private s_bearGuessorBalance;
    uint256 private s_lastPrice;
    uint256 private s_lastTimeStamp;
    AggregatorV3Interface private s_dataFeed;
    PriceGuessState private s_priceGuessState;

    /** Events */
    event PriceGuessEntered(address indexed player, bool isBull);
    event PriceGuessCycleSettled(bool isBull);

    constructor(address dataFeedAddr) {
        s_dataFeed = AggregatorV3Interface(dataFeedAddr);

        s_priceGuessState = PriceGuessState.OPEN;
        s_lastTimeStamp = block.timestamp;
    }

    /** Functions */
    function enterPriceGuess(bool isBull) public payable {
        if (msg.value < ENTRANCE_FEE) {
            revert PriceGuess__NotEnoughETHSent();
        }
        if (s_priceGuessState != PriceGuessState.OPEN) {
            revert PriceGuess__NotOpen();
        }

        if (isBull) {
            s_bullGuessors.push(payable(msg.sender));
            s_bullGuessorBalance += msg.value;
        } else {
            s_bearGuessors.push(payable(msg.sender));
            s_bearGuessorBalance += msg.value;
        }

        emit PriceGuessEntered(msg.sender, isBull);
    }

    function checkUpkeep(
        bytes memory /* checkData */
    ) public view returns (bool upkeepNeeded, bytes memory /* performData */) {
        bool hasEnoughTimePassed = (block.timestamp - s_lastTimeStamp) >=
            INTERVAL;
        bool isOpen = (s_priceGuessState == PriceGuessState.OPEN);
        bool hasPlayers = s_bullGuessors.length > 0 &&
            s_bearGuessors.length > 0;

        upkeepNeeded = (hasEnoughTimePassed && isOpen && hasPlayers);
    }

    function performUpkeep(bytes calldata /* performData */) public {
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert PriceGuess__UpkeepNotNeeded();
        }

        s_priceGuessState = PriceGuessState.SETTLING;

        uint256 latestPrice = uint256(getETHUSDLatestPrice());
        bool answerIsBull = latestPrice > s_lastPrice ? true : false;

        s_lastPrice = latestPrice;
        settle(answerIsBull);
    }

    function settle(bool isBull) internal {
        if (isBull) {
            s_bearGuessorBalance = (s_bearGuessorBalance * 19) / 20;
            uint256 winnerShare = s_bearGuessorBalance / s_bullGuessors.length;
            for (uint i = 0; i < s_bullGuessors.length; i++) {
                s_bullGuessors[i].transfer(winnerShare);
            }
        } else {
            s_bullGuessorBalance = (s_bullGuessorBalance * 19) / 20;
            uint256 winnerShare = s_bullGuessorBalance / s_bearGuessors.length;
            for (uint i = 0; i < s_bearGuessors.length; i++) {
                s_bearGuessors[i].transfer(winnerShare);
            }
        }

        s_priceGuessState = PriceGuessState.OPEN;
        s_lastTimeStamp = block.timestamp;
        s_bullGuessors = new address payable[](0);
        s_bearGuessors = new address payable[](0);

        emit PriceGuessCycleSettled(isBull);
    }

    function getETHUSDLatestPrice() private view returns (int256 answer) {
        (, answer, , , ) = s_dataFeed.latestRoundData();
    }

    /** Getter Functions */
    function getEntranceFee() public pure returns (uint256) {
        return ENTRANCE_FEE;
    }

    function getGameState() public view returns (PriceGuessState) {
        return s_priceGuessState;
    }

    function getLastPrice() public view returns (uint256) {
        return s_lastPrice;
    }
}
