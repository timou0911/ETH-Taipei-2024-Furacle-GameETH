// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PriceGuess} from "../src/PriceGuess.sol";
import {DeployPriceGuess} from "../script/DeployPriceGuess.s.sol";

contract PriceGuessTest is Test {
    PriceGuess priceGuess;

    uint256 constant ENTRANCE_FEE = 0.01 ether;
    uint256 constant STARTING_BALANCE = 0.1 ether;
    uint256 constant INTERVAL = 12 hours;

    address user1 = makeAddr("USER1");

    function setUp() external {
        DeployPriceGuess deployPriceGuess = new DeployPriceGuess();
        priceGuess = deployPriceGuess.run();

        vm.deal(user1, STARTING_BALANCE);
    }

    function testEnterPriceGuessWithLessValueThanEntranceFee() public {
        vm.prank(user1);
        vm.expectRevert(PriceGuess.PriceGuess__NotEnoughETHSent.selector);
        priceGuess.enterPriceGuess{value: 0.001 ether}(true);
    }

    function testDataFeedDoesResponse() public view {
        int256 latestPrice = priceGuess.getETHUSDLatestPrice();
        console.log(uint256(latestPrice) / 10e7);
        assert(latestPrice > 0);
    }
}
