// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/ACE.min.sol";

contract ACETest is Test {
    ACE public ace;

    function setUp() public {
        ace = new ACE(address(this));
    }

    function testSymbol() public {
        assertEq(ace.symbol(), "ACE");
    }
}
