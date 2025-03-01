// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Treasury is Ownable {
    uint256 public balance;

    using Address for address payable;
    event DonatedEther(address to, uint256 amount);
    event Received(address from, uint256 amount);

    //Function to transfer ownership of Treasury to a DAO
    function setDAO(address _dao) external onlyOwner {
        require(_dao != address(0), "Invalid address");
        transferOwnership(_dao);
    }

    // Function to donate Ether to an owner address
    function donateEther(
        address payable to,
        uint256 amount
    ) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        to.sendValue(amount);
        emit DonatedEtherEther(to, amount);
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {
        emit Received(msg.sender, msg.value);
        balance += msg.value;
    }
}
