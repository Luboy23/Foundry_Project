// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {DeployManualToken} from "../script/DeployManualToken.s.sol";
import {ManualToken} from "../src/ManualToken.sol";

contract ManualTokenTest is Test {
    ManualToken public manualToken;
    DeployManualToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    uint8 constant public DECIMALS = 18;

    uint256 public constant INITIAL_SUPPLY = 100 ether;
    uint256 public constant STARTING_BALANCE = 10 ether;
    uint256 public constant TRANSFER_BALANCE = 1 ether;


    function setUp() public {
        deployer = new DeployManualToken();
        manualToken = deployer.run();
    }

    function testManualTokenHasRightSetup() public {
        assertEq(manualToken.getBalance(msg.sender), INITIAL_SUPPLY * 10 ** uint256(DECIMALS));
        assert(keccak256(abi.encode(manualToken.getName())) == keccak256(abi.encode("LULUTOKEN")));
        assert(keccak256(abi.encode(manualToken.getSymbol())) == keccak256(abi.encode("LLT")));
    }

    function testApproveCanRunCorrectly() public {
        vm.prank(msg.sender);
        manualToken.approve(alice, TRANSFER_BALANCE);
        assertEq(manualToken.getAllowance(msg.sender, alice), TRANSFER_BALANCE);

        manualToken.transfer(alice,TRANSFER_BALANCE);
        assertEq(manualToken.getBalance(alice),TRANSFER_BALANCE);
        console.log(address(alice).balance);

        
    }

    function testTransferCanRunCorrectly() public {
        vm.prank(msg.sender);
        manualToken.transfer(bob,TRANSFER_BALANCE);
        assertEq(manualToken.getBalance(bob),TRANSFER_BALANCE);
        console.log(address(bob).balance);
    }

        function testTransferFromCanRunCorrectly() public {
        vm.prank(msg.sender);
        manualToken.transferFrom(msg.sender,alice,TRANSFER_BALANCE);
        assertEq(manualToken.getBalance(msg.sender), INITIAL_SUPPLY - TRANSFER_BALANCE);

        console.log(address(alice).balance);
    }


}
