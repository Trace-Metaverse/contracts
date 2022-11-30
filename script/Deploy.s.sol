// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../src/ACE.min.sol";
import "../src/TRC.min.sol";
import "../src/Vesting.min.sol";

contract Tokens is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ACE ACE_TOKEN = new ACE();
        TRC TRC_TOKEN = new TRC();
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

contract Vesting is Script {

    address TRC_TOKEN = address(0x1fA02b2d6A771842690194Cf62D91bdd92BfE28d); // CHANGE TRC_TOKEN!
    address TV_CONTRACT = address(0xdbC43Ba45381e02825b14322cDdd15eC4B3164E6); // CHANGE TV_CONTRACT!

    address[21] adrs = [
        0x813d71359D8B2D663E9af767B509C429F4A73D7F, // team
        0xf915ED498c610C2EA634d9e7C8C10f211711812b, // partners
        0x5D0d32aC4E4AB4d5e7F9CB337Af3f2A1b151A428, // seed
        0x9f391D569985f8dDF533422506f381b24292E6F8, // private
        0xbd2F6719108B320CB958F183B8FEAe2072461A7E, // strategic
        0x1B35DdeD7da4764b9f7005347bD7e98D0D0E3670, // strategic
        0x67Af114ecB144d992Bf38f62ec6a4aE7Ec9C2cB7, // strategic
        0xb9DaE143aa92dD306B4C0b547C376CC6A7263067, // strategic
        0x933a7bd300Bc7AF1e4793a6470c02124CC6d44B9, // strategic
        0x783B88423559bB644b487c978482cEcBe3514Cc1, // strategic
        0xD706fbd1aaf74bEe474Ba912D07Ea7D3B658e0C7, // strategic
        0xdC67DAd2853915aF0BE07A8E0B9fb538E6E87D51, // strategic
        0x77dd2724cF0C88b6D21D5Ae67e3B7Ce1AF93C5bf, // strategic
        0x4C7379B8f2DF5db6Cb666341359Ecd10777cf28A, // strategic
        0x645251650052BF8a945608b035dE8C09F498Df3a, // strategic
        0xd309C9a5dE9f8a776A5342Ae3eb4963F989156D4, // ambasador
        0x6cF8F5060dE09D5837C0f294843E39949F585e36, // preSale
        0x18969c84F2b98d569023Ee2d145fc6ae88A73a14, // publicSale
        0xd3553d41f3BCE3237209791fD004Fb51d85dEeC9, // marketing
        0x200018D215974126CD9eF59f147A64f243dc78ec, // rewards
        0x7f2Dd1ca0CA23124D43ED4e9fbE4e8a8446D7bB8  // ecosystem
    ];

    struct Group {
        address beneficiary;
        uint256 percentAll;
        uint256 percentTge;
        uint256 percentMonth;
        uint256 cliff;
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Group[21] memory groups = [
            // 4% Unlocked every month starting from 12th
            Group({
                beneficiary: adrs[0],
                percentAll: 1000,
                percentTge: 0,
                percentMonth: 400,
                cliff: 12
            }),
            // 3% Unlocked every month starting from 4th
            Group({
                beneficiary: adrs[1],
                percentAll: 300,
                percentTge: 0,
                percentMonth: 300,
                cliff: 4
            }), 
            // 4% unlocked at TGE, 4m cliff, 2% unlock every month
            Group({
                beneficiary: adrs[2],
                percentAll: 500,
                percentTge: 400,
                percentMonth: 200,
                cliff: 4
            }),
            // 5% unlocked at TGE, 4m cliff, 5% unlock every month
            Group({
                beneficiary: adrs[3],
                percentAll: 225,
                percentTge: 500,
                percentMonth: 500,
                cliff: 4
            }), 
            // 5% unlocked at TGE, 2m cliff, 3,5% unlock every month
            Group({
                beneficiary: adrs[4],
                percentAll: 100,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[5],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[6],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[7],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[8],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[9],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[10],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[11],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[12],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[13],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            Group({
                beneficiary: adrs[14],
                percentAll: 60,
                percentTge: 500,
                percentMonth: 350,
                cliff: 2
            }),
            // 6% unlocked at TGE, 1m cliff, 5% unlock every month
            Group({
                beneficiary: adrs[15],
                percentAll: 225,
                percentTge: 600,
                percentMonth: 500,
                cliff: 1
            }),
            // 6% unlocked at TGE, 1m cliff, 5% unlock every month
            Group({
                beneficiary: adrs[16],
                percentAll: 100,
                percentTge: 600,
                percentMonth: 500,
                cliff: 1
            }),
            // 10% unlocked at TGE, 1m cliff, 5% unlock every month
            Group({
                beneficiary: adrs[17],
                percentAll: 70,
                percentTge: 1000,
                percentMonth: 500,
                cliff: 1
            }),
            // Linear 4% unlock starting from month 1
            Group({
                beneficiary: adrs[18],
                percentAll: 1280,
                percentTge: 0,
                percentMonth: 400,
                cliff: 1
            }),
            // See rewards tab
            Group({
                beneficiary: adrs[19],
                percentAll: 4100,
                percentTge: 0,
                percentMonth: 250,
                cliff: 1
            }),
            // 0,6% unlocked at TGE 2% Linear unlock starting from month 2
            Group({
                beneficiary: adrs[20],
                percentAll: 1500,
                percentTge: 60,
                percentMonth: 200,
                cliff: 2
            })
        ];

        uint256 _all = 5_000_000_000 * 10**18;
        uint256 day = 86_400;
        uint256 month = day * 30;

        for (uint8 i = 0; i < 21; i++) {
            uint256 _duration = 10000 / groups[i].percentMonth; // 100% / MONTH% = All Months
            uint256 _amountAll = (_all * groups[i].percentAll) / 10000;
            uint256 _amountTge = (_amountAll * groups[i].percentTge) / 10000;
            uint256 _amount = _amountAll - _amountTge;
            if (_amountTge > 0) {
                TRC(address(TRC_TOKEN)).transfer(groups[i].beneficiary, _amountTge);
            }
            TRC(address(TRC_TOKEN)).transfer(address(TV_CONTRACT), _amount);
            TV(payable(TV_CONTRACT)).createVestingSchedule(
                groups[i].beneficiary,
                block.timestamp + 1 * month,
                groups[i].cliff * month,
                _duration * month,
                day,
                true, 
                _amount
            );
            console.logUint(i);
            console.logUint(_amount);
            console.logAddress(address(groups[i].beneficiary));
        }

        TRC(address(TRC_TOKEN)).pause();

        vm.stopBroadcast();
    }
}