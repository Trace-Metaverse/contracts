// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/CAR.min.sol";

contract TraceNFTCarTest is Test {
    TraceNFTCar public car;

    function setUp() public {
        car = new TraceNFTCar();
    }

    function testSymbol() public {
        assertEq(car.symbol(), "CAR");
    }
}
