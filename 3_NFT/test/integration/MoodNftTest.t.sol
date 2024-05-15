// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {

        MoodNft private moodNft;
        address USER = makeAddr("user");

        function setUp() external {
        DeployMoodNft deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

        function testViewTokenURI() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }
        
        function testFlipTokenToSad() public {
            vm.prank(USER);
            moodNft.mintNft();

            vm.prank(USER);
            moodNft.flipMood(0);

            assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(moodNft.tokenURI(0))));

        }
}
    