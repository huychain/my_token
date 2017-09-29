pragma solidity ^0.4.15;

contract owned {
  address public owner;

  function owned() {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) onlyOwner {
    owner = newOwner;
  }
}

contract MyToken is owned {
	// This creates an array with all balances
	mapping (address => uint256) public balanceOf;
	mapping (address => bool) public frozenAccount;

	string public name;
	string public symbol;
	uint8 public decimals;
	uint256 public totalSupply;

	event Transfer(address indexed from, address indexed to, uint256 value);
	event FrozenFunds(address target, bool frozen);

	function MyToken(
		uint256 initialSupply,
    string tokenName,
    uint8 decimalUnits,
    string tokenSymbol,
    address centralMinter
	) {
		if (centralMinter != 0) owner = centralMinter;
		totalSupply = initialSupply;
    balanceOf[msg.sender] = initialSupply;    // Give the creator all initial tokens
    name = tokenName;                         // Set the name for display purposes
    symbol = tokenSymbol;                     // Set the symbol for display purposes
    decimals = decimalUnits;                  // Amount of decimals for display purposes
	}

	function mintToken(address target, uint256 mintedAmount) onlyOwner {
		balanceOf[target] += mintedAmount;
		totalSupply += mintedAmount;
		Transfer(0, owner, mintedAmount);
		Transfer(owner, target, mintedAmount);
	}

	function freezeAccount(address target, bool freeze) onlyOwner {
		frozenAccount[target] = freeze;
		FrozenFunds(target, freeze);
	}

	// function transfer(address _to, uint256 _value) {
	// 	// Check if sender has balance and for overflows
	// 	require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

	// 	// Add and subtract new balances
	// 	balanceOf[msg.sender] -= _value;
	// 	balanceOf[_to] += _value;

	// 	// Notify anyone listening that this transfer took place
	// 	Transfer(msg.sender, _to, _value);
	// }

	function _transfer(address _from, address _to, uint _value) internal {
    require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
    require(balanceOf[_from] >= _value);                // Check if the sender has enough
    require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
    require(!frozenAccount[_from]);                     // Check if sender is frozen
    require(!frozenAccount[_to]);                       // Check if recipient is frozen
    balanceOf[_from] -= _value;                         // Subtract from the sender
    balanceOf[_to] += _value;                           // Add the same to the recipient
    Transfer(_from, _to, _value);
	}
}