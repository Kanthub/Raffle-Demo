// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";

contract Raffle is VRFConsumerBaseV2Plus, AutomationCompatibleInterface {
    // Errors Definition
    error Raffle__SendMoreToEnterRaffle();
    error Raffle_Givemequicknode();
    error Raffle__EntranceNotOpenNow();
    error Raffle__UpKeepNotNeeded(
        uint256 balance,
        uint256 numberOfMembers,
        uint256 raffleState
    );

    // Type Declaration
    enum RaffleState {
        OPEN,
        CLOSE
    }

    // VRF Declarations
    uint256 s_subscriptionId;
    address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    bytes32 s_keyHash =
        0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 callbackGasLimit = 500000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;

    // State Variables
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    RaffleState private s_RaffleState;
    address[] private s_players;
    address private s_winner;
    uint256 private s_lastTimeStamp;

    // Events
    event RaffleEntered(address indexed player);
    event RequestRandomNumber(uint256 indexed requestId);
    event RandomNumberUsed(uint256 indexed requestId);
    event WinnerPicked(address indexed winner);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        uint256 subscriptionId
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        s_subscriptionId = subscriptionId;
        s_RaffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        i_interval = interval;
    }

    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee, "Not enough value sent");
        // require(s_raffleState == RaffleState.OPEN, "Raffle is not open");
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        } else if (s_RaffleState == RaffleState.CLOSE) {
            revert Raffle__EntranceNotOpenNow();
        }
        s_players.push(msg.sender);
        emit RaffleEntered(msg.sender);
    }

    // function upKeepCheck
    function checkUpkeep(
        bytes memory /* checkData */
    )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        bool isOpen = s_RaffleState == RaffleState.OPEN;
        bool hasMember = s_players.length > 1;
        bool hasBalance = address(this).balance > 0;
        bool timeHasPast = (block.timestamp - s_lastTimeStamp) > i_interval;
        upkeepNeeded = (isOpen && hasMember && hasBalance && timeHasPast);
        return (upkeepNeeded, "0x0");
    }

    function performUpkeep(bytes calldata /* performData */) external override {
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Raffle__UpKeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_RaffleState)
            );
        }
        s_RaffleState = RaffleState.CLOSE;
        requestRandomNumber();
    }

    function requestRandomNumber() public returns (uint256 requestId) {
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
        emit RequestRandomNumber(requestId);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 requestId,
        /* requestId */ uint256[] calldata randomWords
    ) internal override {
        uint256 randomNumber = randomWords[0];
        emit RandomNumberUsed(requestId);
        pickWinner(randomNumber);
    }

    function pickWinner(uint256 randomNumber) public {
        uint256 indexOfWinner = randomNumber % s_players.length;
        s_winner = s_players[indexOfWinner];
        emit WinnerPicked(s_winner);
        s_RaffleState = RaffleState.OPEN;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;
        (bool success,) = s_winner.call{value: address(this).balance}("");
        
    }

    receive() external payable {
        // enterRaffle();
    }

    fallback() external payable {
        // enterRaffle();
    }

    function getWinner() public view returns (address) {
        return s_winner;
    }

    function getRaffleState() public view returns (uint256) {
        return uint256(s_RaffleState);
    }
}

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions
