// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/TRC.min.sol";
import "../src/Vesting.min.sol";

contract VestingTest is Test {
    TRC public trc;
    TV public tv;

    struct Group {
        address beneficiary;
        uint256 percentAll;
        uint256 percentTge;
        uint256 percentMonth;
        uint256 cliff;
    }

    function setUp() public {
        trc = new TRC();
        tv = new TV(address(trc));
    }

    function testDeployTRC() public {
        assertEq(trc.symbol(), "TRC");
    }

    function testVesting() public {
        address[1] memory adrs = [
            0x813d71359D8B2D663E9af767B509C429F4A73D7F // team
        ];

        Group[1] memory groups = [
            // 4% Unlocked every month starting from 12th
            Group({
                beneficiary: adrs[0],
                percentAll: 1000,
                percentTge: 0,
                percentMonth: 400,
                cliff: 12
            })
        ];

        uint256 _all = 5_000_000_000 * 10**18;
        uint256 day = 86_400;
        uint256 month = day * 30;

        for (uint8 i = 0; i < 1; i++) {
            uint256 _duration = 10000 / groups[i].percentMonth; // 100% / MONTH% = All Months
            uint256 _amountAll = (_all * groups[i].percentAll) / 10000;
            uint256 _amountTge = (_amountAll * groups[i].percentTge) / 10000;
            uint256 _amount = _amountAll - _amountTge;
            if (_amountTge > 0) {
                TRC(address(trc)).transfer(groups[i].beneficiary, _amountTge);
            }
            TRC(address(trc)).transfer(address(tv), _amount);
            TV(payable(tv)).createVestingSchedule(
                groups[i].beneficiary,
                block.timestamp + 1 * month,
                groups[i].cliff * month,
                _duration * month,
                day,
                true, 
                _amount
            );
        }

        bytes32 id = TV(tv).getVestingIdAtIndex(0);

        assertEq(TV(tv).computeReleasableAmount(id), 0);

        TV.VestingSchedule memory vestingSchedule = TV(tv).getVestingSchedule(id);

        assertEq(vestingSchedule.beneficiary, groups[0].beneficiary);
        assertEq(vestingSchedule.start, block.timestamp + 1 * month);
        assertEq(vestingSchedule.cliff, (block.timestamp + 1 * month) + (groups[0].cliff * month));
        assertEq(vestingSchedule.duration, 10000 / groups[0].percentMonth * month);
        assertEq(vestingSchedule.slicePeriodSeconds, day);

        uint256 timestamp = vestingSchedule.cliff + month * 2;

        vm.warp(timestamp);
        // 500_000_000_000000000000000000
        //  40_000_000_000000000000000000

        uint256 releasableAmount = TV(tv).computeReleasableAmount(id);
        assertEq(releasableAmount, 40_000_000 * 10**18);

        TV(tv).release(id, releasableAmount);
        assertEq(TV(tv).getVestingSchedule(id).released, 40_000_000 * 10**18);

        timestamp = vestingSchedule.cliff + vestingSchedule.duration - month;
        vm.warp(timestamp);
        // 500_000_000_000000000000000000
        // 440_000_000_000000000000000000

        releasableAmount = TV(tv).computeReleasableAmount(id);
        assertEq(releasableAmount, 440_000_000 * 10**18);

        TV(tv).release(id, releasableAmount);
        assertEq(TV(tv).getVestingSchedule(id).released, 480_000_000 * 10**18);

        timestamp = vestingSchedule.cliff + vestingSchedule.duration;
        vm.warp(timestamp);
        // 500_000_000_000000000000000000
        //  20_000_000_000000000000000000

        releasableAmount = TV(tv).computeReleasableAmount(id);
        assertEq(releasableAmount, 20_000_000 * 10**18);

        TV(tv).release(id, releasableAmount);
        assertEq(TV(tv).getVestingSchedule(id).released, 500_000_000 * 10**18);
    }
}
