//  SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/**
 * @title 抽奖合约
 * @author lllu_23
 * @notice 此合约是为了实现一个几乎随机的抽奖合约
 * @dev 使用了 Chainlink 相关的函数功能
 */

contract Raffle is VRFConsumerBaseV2 {
    error Raffle__NotEnoughEth();
    error Raffle__TransferFailed();
    error Raffle__RaffleNotOpen();
    error Raffle__UpkeepNotNeeded(uint256 currentBalance, uint256 numPlayers, RaffleState raffleState);

    enum RaffleState {
        OPEN,
        CALCULATING
    }

    uint16 private constant REQUEST_CONFIRMATION = 3;
    uint32 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee;

    // @dev 这个抽奖持续的时间（单位：秒）
    uint256 private immutable i_interval;

    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    address private s_recentwinner;
    RaffleState private s_raffleState;

    /**
     * 事件
     */
    event EnterRaffle(address indexed player);
    event WinnerPicked(address indexed winner);
    event RequestedRaffleWinner(uint256 indexed requestId);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_subscriptionId = subscriptionId;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_callbackGasLimit = callbackGasLimit;

        s_raffleState = RaffleState.OPEN;
    }

    function enterRaffle() external payable {
        //  检查用户是否有足够的资金参与抽奖
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEth();
        }

        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }

        //  记录参与抽奖的玩家
        s_players.push(payable(msg.sender));

        //  触发事件
        emit EnterRaffle(msg.sender);
    }

    /**
     * @dev  使用 Chainlink Automation 以实现自动化
     * 是否到了自动执行的时间
     * 应当满足以下条件
     * 1. 抽奖已经开始了足够长的时间
     * 2. Raffle 合约的状态（RaffleState）应该为 OPEN 状态
     * 3. 合约内有足够的 ETH（也就是有玩家参与抽奖）
     * 4. subscription 有足够的 LINK 支持
     */
    function checkUpkeep(bytes memory)
        /**
         * checkData
         */
        public
        view
        returns (bool upkeepNeeded, bytes memory)
    /**
     * performData
     */
    {
        //  查看是否经历了足够的时间
        bool timeHasPassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
        bool isOpen = RaffleState.OPEN == s_raffleState;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;
        upkeepNeeded = (timeHasPassed && isOpen && hasBalance && hasPlayers);
        return (upkeepNeeded, "0x0");
    }

    //  1. 获得随机数
    //  2. 使用此随机数来选取赢家
    //  3. 自动调用此函数
    function performUpkeep(bytes calldata)
        /**
         * performData
         */
        external
    {
        (bool upkeepNeeded,) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(address(this).balance, s_players.length, s_raffleState);
        }

        s_raffleState = RaffleState.CALCULATING;

        //  1. 获取 RNG
        //  2. 获取随机数
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, i_subscriptionId, REQUEST_CONFIRMATION, i_callbackGasLimit, NUM_WORDS
        );
        emit RequestedRaffleWinner(requestId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];

        s_recentwinner = winner;
        s_raffleState = RaffleState.OPEN;

        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;

        emit WinnerPicked(winner); //   时刻都要遵循 C-E-I 原则！！！

        (bool success,) = winner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    /**
     * Getter Function
     */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() external view returns (RaffleState) {
        return s_raffleState;
    }

    function getPlayer(uint256 indexOfPlayer) external view returns (address) {
        return s_players[indexOfPlayer];

    }
            
        function getRecentWinner() external view returns(address) {
            return s_recentwinner;
        }

        function getLengthOfPlayers() external view returns(uint256){
            return s_players.length;
        }

        function getLastTimeStamp() external view returns(uint256)  {
            return s_lastTimeStamp;
        }
}
