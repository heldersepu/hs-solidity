// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Lottery is Ownable {
    address[] private tickets;
    address public winner;

    uint256 public ticketPrice;
    uint256 public ticketCount;
    uint256 public ticketsLeft;

    constructor(uint256 _ticketPrice, uint256 _ticketCount) {
        ticketPrice = _ticketPrice;
        ticketCount = _ticketCount;
        ticketsLeft = _ticketCount;
    }

    function buy() public payable {
        require(msg.value == ticketPrice, "invalid value");

        tickets.push(msg.sender);
        ticketsLeft--;

        if (ticketsLeft == 0) {
            bytes memory b1 = abi.encodePacked(block.timestamp, block.difficulty, ticketCount);
            bytes32 b2 = keccak256(b1);
            uint256 num = uint256(b2);
            winner = tickets[num % ticketCount];
            address payable receiver = payable(winner);
            receiver.transfer(address(this).balance);
        }
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getTickets() public view returns (address[] memory) {
        return tickets;
    }
}
