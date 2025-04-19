// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract createTokenBaseSQSC {
    address[] public deployedTokens;

    event TokenCreated(address tokenAddress, string name, string symbol, uint256 totalSupply, uint8 decimals, address owner);

    function createToken(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        uint8 _decimals,
        address _recipient
    ) public returns (address) {
        require(_decimals <= 18, "Max decimals is 18");
        CustomERC20 newToken = new CustomERC20(_name, _symbol, _totalSupply, _decimals, _recipient);
        deployedTokens.push(address(newToken));
        emit TokenCreated(address(newToken), _name, _symbol, _totalSupply, _decimals, _recipient);
        return address(newToken);
    }

    function getAllTokens() public view returns (address[] memory) {
        return deployedTokens;
    }
}

contract CustomERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        uint8 _decimals,
        address _recipient
    ) {
        require(_decimals <= 18, "Max decimals is 18");
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * (10 ** uint256(_decimals));
        balanceOf[_recipient] = totalSupply;
        emit Transfer(address(0), _recipient, totalSupply);
    }

    function transfer(address _to, uint256 _amount) public returns (bool) {
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) public returns (bool) {
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
        require(balanceOf[_from] >= _amount, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _amount, "Allowance exceeded");
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
        allowance[_from][msg.sender] -= _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }
}
