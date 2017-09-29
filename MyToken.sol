pragma solidity ^0.4.15;

contract MyToken {
    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;

    function MyToken(uint256 initialSupply) {
    	balanceOf[msg.sender] = initialSupply;
		}
}