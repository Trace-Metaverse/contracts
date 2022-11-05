// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../src/ACE.min.sol";
import "../src/TRC.min.sol";
import "../src/Vesting.min.sol";

contract TokenScript is Script {

    address admin_ = address(this);

    function run() public {
        vm.startBroadcast();

        ACE ACE_TOKEN = new ACE(admin_);
        TRC TRC_TOKEN = new TRC(admin_);
        TV TV_CONTRACT = new TV(address(TRC_TOKEN));

        console.logString("ACE_TOKEN:");
        console.logAddress(address(ACE_TOKEN));

        console.logString("TRC_TOKEN:");
        console.logAddress(address(TRC_TOKEN));

        console.logString("TV_CONTRACT:");
        console.logAddress(address(TV_CONTRACT));

        vm.stopBroadcast();
    }
}

contract VestingScript is Script {

    address admin_ = address(this);

    address team_ = 0x813d71359D8B2D663E9af767B509C429F4A73D7F;
    address partners_ = 0xf915ED498c610C2EA634d9e7C8C10f211711812b;
    address seed_ = 0x5D0d32aC4E4AB4d5e7F9CB337Af3f2A1b151A428;
    address private_ = 0x9f391D569985f8dDF533422506f381b24292E6F8;
    address strategic_ = 0x750879B1c38cDfD054563f1Ec5764631f0E53bE7;
    address ambasador_  = 0xd309C9a5dE9f8a776A5342Ae3eb4963F989156D4;
    address preSale_ = 0x6cF8F5060dE09D5837C0f294843E39949F585e36;
    address publicSale_ = 0x18969c84F2b98d569023Ee2d145fc6ae88A73a14;
    address marketing_ = 0xd3553d41f3BCE3237209791fD004Fb51d85dEeC9;
    address rewards_ = 0x200018D215974126CD9eF59f147A64f243dc78ec;
    address ecosystem_ = 0x7f2Dd1ca0CA23124D43ED4e9fbE4e8a8446D7bB8;

    address TRC_TOKEN = address(0); // CHANGE TRC_TOKEN!
    address TV_CONTRACT = address(0); // CHANGE TV_CONTRACT!

    struct Group {
        address beneficiary;
        uint256 percentAll;
        uint256 percentTge;
        uint256 percentMonth;
        uint256 cliff;
    }

    Group[] public groups;

    function setUp() public {

        // 4% Unlocked every month starting from 12th
        Group memory g1 = Group({
            beneficiary: team_,
            percentAll: 1000,
            percentTge: 0,
            percentMonth: 400,
            cliff: 12
        });

        // 3% Unlocked every month starting from 4th
        Group memory g2 = Group({
            beneficiary: partners_,
            percentAll: 300,
            percentTge: 0,
            percentMonth: 300,
            cliff: 4
        });

        // 4% unlocked at TGE, 4m cliff, 2% unlock every month
        Group memory g3 = Group({
            beneficiary: seed_,
            percentAll: 500,
            percentTge: 400,
            percentMonth: 200,
            cliff: 4
        });

        // 5% unlocked at TGE, 4m cliff, 5% unlock every month
        Group memory g4 = Group({
            beneficiary: private_,
            percentAll: 225,
            percentTge: 500,
            percentMonth: 500,
            cliff: 4
        });

        // 5% unlocked at TGE, 2m cliff, 3,5% unlock every month
        Group memory g5 = Group({
            beneficiary: strategic_,
            percentAll: 700,
            percentTge: 500,
            percentMonth: 350,
            cliff: 2
        });

        // 6% unlocked at TGE, 1m cliff, 5% unlock every month
        Group memory g6 = Group({
            beneficiary: ambasador_,
            percentAll: 225,
            percentTge: 600,
            percentMonth: 500,
            cliff: 1
        });

        // 6% unlocked at TGE, 1m cliff, 5% unlock every month
        Group memory g7 = Group({
            beneficiary: preSale_,
            percentAll: 100,
            percentTge: 600,
            percentMonth: 500,
            cliff: 1
        });

        // 10% unlocked at TGE, 1m cliff, 5% unlock every month
        Group memory g8 = Group({
            beneficiary: publicSale_,
            percentAll: 70,
            percentTge: 1000,
            percentMonth: 500,
            cliff: 1
        });

        // Linear 4% unlock starting from month 1
        Group memory g9 = Group({
            beneficiary: marketing_,
            percentAll: 1280,
            percentTge: 0,
            percentMonth: 400,
            cliff: 1
        });

        // See rewards tab
        Group memory g10 = Group({
            beneficiary: rewards_,
            percentAll: 4100,
            percentTge: 0,
            percentMonth: 250,
            cliff: 1
        });

        // 0,6% unlocked at TGE 2% Linear unlock starting from month 2
        Group memory g11 = Group({
            beneficiary: ecosystem_,
            percentAll: 1500,
            percentTge: 60,
            percentMonth: 200,
            cliff: 2
        });

        groups.push(g1);
        groups.push(g2);
        groups.push(g3);
        groups.push(g4);
        groups.push(g5);
        groups.push(g6);
        groups.push(g7);
        groups.push(g8);
        groups.push(g9);
        groups.push(g10);
        groups.push(g11);

    }

    function run() public {
        vm.startBroadcast();

        uint256 _all = 5_000_000_000 * 10**18;
        uint256 day = 86_400;
        uint256 month = day * 30;

        for (uint8 i = 0; i < 1; i++) {
            uint256 _duration = 10000 / groups[i].percentMonth;
            uint256 _amount = (_all * groups[i].percentAll) / 10000;
            uint256 _amountTge = (_amount * groups[i].percentTge) / 10000;
            if (_amountTge > 0) {
                IERC20(TRC_TOKEN).transfer(groups[i].beneficiary, _amountTge);
            }
            IERC20(TRC_TOKEN).transfer(address(TV_CONTRACT), _amount - _amountTge);
            TV(payable(TV_CONTRACT)).createVestingSchedule(
                groups[i].beneficiary, 
                0, 
                groups[i].cliff * month, 
                block.timestamp + _duration * month,
                day,
                true, 
                _amount - _amountTge
            );
        }

        vm.stopBroadcast();
    }
}