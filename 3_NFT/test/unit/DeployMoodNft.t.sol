//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testDeployMoodNftWorksProperlyOnAllChains() public {
        vm.chainId(31337);
        MoodNft moodNft_1 = deployer.run();

        vm.chainId(11155111);
        MoodNft moodNft_2 = deployer.run();

        assertEq(address(moodNft_1), address(MoodNft(address(moodNft_1))));
        assertEq(address(moodNft_2), address(MoodNft(address(moodNft_2))));
    }

    function testConvertSvgToUri() public view {
        string memory happy_svg = vm.readFile("images/dynamicNft/happy.svg");
        string memory expectUri =
            "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";
        string memory actualUri = deployer.svgToImageURI(happy_svg);

        console.log(actualUri);
        assert(keccak256(abi.encodePacked(actualUri)) == keccak256(abi.encodePacked(expectUri)));
    }
}

