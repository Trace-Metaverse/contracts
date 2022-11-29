// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/TRC.min.sol";

contract TRCTest is Test {
    TRC public trc;

    function setUp() public {
        trc = new TRC();
    }

    function testSymbol() public {
        assertEq(trc.symbol(), "TRC");
    }
}
