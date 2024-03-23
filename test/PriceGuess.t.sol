// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PriceGuess} from "../src/PriceGuess.sol";
import {DeployPriceGuess} from "../script/DeployPriceGuess.s.sol";

contract CounterTest is Test {
    PriceGuess priceGuess;

    function setUp() public {
        DeployPriceGuess deployPriceGuess = new DeployPriceGuess();
        priceGuess = deployPriceGuess.run();
    }
}
