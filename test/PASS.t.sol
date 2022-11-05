// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/PASS.min.sol";

contract TraceNFTPassTest is Test {
    TraceNFTPass public pass;

    function setUp() public {
        pass = new TraceNFTPass();
    }

    function testSymbol() public {
        assertEq(pass.symbol(), "PASS");
    }
}
