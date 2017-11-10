pragma solidity ^0.4.15;
import "./lib/itMaps.sol";
import "./lib/SafeMath.sol";

/**
 * The setTokenPrice contract does this and that...
 */
contract ERC20_ETH {


	
	using itMaps for itMaps.itMapAddressUint;
	using SafeMath for uint256;
	
	uint8 public constant decimals = 4;
	uint256 public totalSupply = 1000000;
	string public constant symbol = "Iterable";

	uint256 public constant amountOfEthereum = this.balance; 
	
	uint256 private tokenPrice;	
	address public firstOwner;
	address public secondOwner;
	uint256 private balanceFirstOwner;
	uint256 private balanceSecondOwner;
	

	itMaps.itMapAddressUint tokensBalances;
	itMaps.itMapAddressUint ethereumBalances;

	mapping (address => mapping (address => uint256)) allowed;

	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
	
	
	function ERC20_ETH() {
		firstOwner = msg.sender;
		secondOwner = openKeySecondOwner;

		balanceFirstOwner = totalSupply/4;
		balanceSecondOwner = totalSupply - balanceFirstOwner;

		tokensBalances.insert(firstOwner,balanceFirstOwner);
		tokensBalances.insert(secondOwner,balanceSecondOwner);			
	}

	function()payable{
		shares_ETH();
	}

    function getTokenPrice()constant returns(uint256) {
    	return tokenPrice;
    }
 
	function shares_ETH() private{
		uint256 value;
		address key;
		
		tokenPrice = amountOfEthereum.div(totalSupply);

		for(uint i =0; i < tokensBalances.size(); i++){
			value = tokensBalances.getValueByIndex(i);
			key = tokensBalances.getKeyByIndex(i);

			ethereumBalances.insert(key, value.mul(getTokenPrice()));
		}
	}

	function balanceOf_ETH(address _addressOwner) constant returns(uint256 _balances){	
		_balances = ethereumBalances.get(_addressOwner);
		return _balances;
	}
    
    
	function transfer_ETH(address _to, uint256 _amount) returns(bool success){
		if((ethereumBalances.get(msg.sender) >= _amount)&&(_amount >0)){
			ethereumBalances.insert(_to, ethereumBalances.get(_to) + _amount);
			ethereumBalances.insert(msg.sender,(ethereumBalances.get(msg.sender) - _amount));
			Transfer(msg.sender, _to, _amount);
			return true;
		}		
		else{
			return false;
		}
	}
	
	function approve_ETH(address _spender, uint256 _amount) returns(bool success) {
		allowed[msg.sender][_spender] = _amount;
		Approval(msg.sender, _spender,_amount);
		return true;
	}

	function transferFrom_ETH(address _from, address _to, uint256 _amount) returns(bool success) {
		if((ethereumBalances.get(_from) >= _amount) && 
			(allowed[_from][msg.sender] >= _amount) && 
			(_amount >0)){
				ethereumBalances.insert(_from, ethereumBalances.get(_from)-_amount);
				allowed[_from][msg.sender]-=_amount;
				ethereumBalances.insert(_to, ethereumBalances.get(_to)+_amount);
				Transfer(_from,_to,_amount);
				return true;
		}
		else{
			return false;
		}
	}	

	function allowance_ETH(address _owner, address _spender)constant returns(uint256 balance) {
		return allowed[_owner][_spender];
	}	
}
