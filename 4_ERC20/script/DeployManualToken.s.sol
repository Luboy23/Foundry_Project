// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {ManualToken} from "../src/ManualToken.sol";

contract DeployManualToken is Script {

    uint256 public constant INITIAL_SUPPLY = 100 ether;
    string public constant NAME = "LULUTOKEN";
    string public constant SYMBOL = "LLT";
    uint8 constant public DECIMALS = 18;



    function run() external returns (ManualToken) {
        vm.startBroadcast();
        ManualToken manualToken = new ManualToken(INITIAL_SUPPLY, NAME, SYMBOL);
        vm.stopBroadcast();
        return manualToken;
    }
}
