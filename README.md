📄 README: createTokenBaseSQSC
Overview
createTokenBaseSQSC is an on-chain smart contract deployed to the Base network that allows any user to create their own custom ERC-20 token directly from the blockchain. Tokens are created by calling a single method with user-defined metadata — including name, symbol, supply, decimals, and a hosted image logo.

🔗 Live Deployment
Network: Base Mainnet

Contract Address: 0xe7c7478ED4Bd64dc0dF8b5281f559b914cAF03fE

Verified on: Basescan

✨ Features
✅ Anyone can create a custom ERC-20 token

✅ Customizable name, symbol, supply, decimals, and image

✅ Lightweight, gas-efficient token logic

✅ Decentralized and permissionless token deployment

✅ Supports hosted .png image URL (for use in dApps or explorers)

🧠 How It Works
Primary Function: createToken(...)
solidity
Copy
Edit
function createToken(
    string memory name,
    string memory symbol,
    uint256 totalSupply,
    uint8 decimals,
    address recipient,
    string memory imageURI
) public returns (address);
Parameters:
name: Name of the token (e.g., "Qawalla Coin")

symbol: Ticker symbol (e.g., "QWLA")

totalSupply: Total number of tokens (whole units)

decimals: Decimal places (max: 18)

recipient: Wallet that receives all initial tokens

imageURI: HTTPS URL pointing to a .png image for the token (e.g., for use in a frontend or token explorer)

🔐 Validation Rules
decimals must be between 0 and 18

imageURI must:

Begin with https://

End with .png

Be at least 9 characters long

📦 Token Standard Compatibility
Each token created via createTokenBaseSQSC is a fully independent ERC-20 compliant contract with:

name, symbol, decimals, totalSupply

balanceOf, transfer, approve, transferFrom, allowance

Additionally, each token stores:

string imageURI – accessible for display use in dApps or token directories.

🛠️ Example Use
To create a token:

solidity
Copy
Edit
createToken(
  "MyToken",
  "MTK",
  1000000,
  18,
  0xYourWallet,
  "https://yourdomain.com/logo.png"
)
📁 Project Structure (if source maintained)
bash
Copy
Edit
├── contracts/
│   └── createTokenBaseSQSC.sol     # Main contract
├── README.md                       # Project overview
🔒 Security Notes
Tokens are owned by the recipient address — not by the contract deployer.

There is no owner, mint, or burn — fixed supply only.

Recommended to verify newly created tokens on Basescan for full transparency.

✅ Next Steps (Optional Enhancements)
You may extend this project with:

Mintable or burnable token options

Metadata registration (e.g., Uniswap Token Lists)

Frontend dApp for public use

Optional token locking or vesting

🧾 License
MIT License — Free to use, fork, and deploy in your own ecosystem.

