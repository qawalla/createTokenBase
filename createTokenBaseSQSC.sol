// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract createTokenBaseSQSC {
    address[] public deployedTokens;

    event TokenCreated(
        address tokenAddress,
        string name,
        string symbol,
        uint256 totalSupply,
        uint8 decimals,
        address owner,
        string imageURI
    );

    function createToken(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        uint8 _decimals,
        address _recipient,
        string memory _imageURI
    ) public returns (address) {
        require(_decimals <= 18, "Max decimals is 18");
        require(isValidPNG(_imageURI), "Invalid image URI. Must be an https link ending in .png");

        CustomERC20 newToken = new CustomERC20(_name, _symbol, _totalSupply, _decimals, _recipient, _imageURI);
        deployedTokens.push(address(newToken));
        emit TokenCreated(address(newToken), _name, _symbol, _totalSupply, _decimals, _recipient, _imageURI);
        return address(newToken);
    }

    function getAllTokens() public view returns (address[] memory) {
        return deployedTokens;
    }

    function isValidPNG(string memory _uri) internal pure returns (bool) {
        bytes memory uriBytes = bytes(_uri);
        if (uriBytes.length < 9) return false; // minimum "https://x.png"

        // check if starts with https://
        if (
            uriBytes[0] != 'h' ||
            uriBytes[1] != 't' ||
            uriBytes[2] != 't' ||
            uriBytes[3] != 'p' ||
            uriBytes[4] != 's' ||
            uriBytes[5] != ':' ||
            uriBytes[6] != '/' ||
            uriBytes[7] != '/'
        ) return false;

        // check if ends with .png
        uint len = uriBytes.length;
        return (
            uriBytes[len - 4] == '.' &&
            uriBytes[len - 3] == 'p' &&
            uriBytes[len - 2] == 'n' &&
            uriBytes[len - 1] == 'g'
        );
    }
}

contract CustomERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    string public imageURI;
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
        address _recipient,
        string memory _imageURI
    ) {
        require(_decimals <= 18, "Max decimals is 18");
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        imageURI = _imageURI;
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
