// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract DeployBasicNftTest is Test {
    DeployBasicNft deployer;

    function setUp() external {
        deployer = new DeployBasicNft();
    }

    function testDeployBasicNftDeploysBasicNftCorrectly() public {
        vm.chainId(31337);
        BasicNft basicNft_1 = deployer.run();

        vm.chainId(11155111);
        BasicNft basicNft_2 = deployer.run();

        assertEq(address(basicNft_1), address(BasicNft(address(basicNft_1))));
        assertEq(address(basicNft_2), address(BasicNft(address(basicNft_2))));
    }
}
