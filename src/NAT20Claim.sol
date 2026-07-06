// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract NAT20Claim {
    IERC20 public immutable token;
    address public immutable treasury;
    uint256 public constant CLAIM_AMOUNT = 1e18; // 1 NAT20 per wallet

    mapping(address => bool) public hasClaimed;
    uint256 public totalClaims;

    event Claimed(address indexed claimer, uint256 amount);

    constructor(address _token, address _treasury) {
        token = IERC20(_token);
        treasury = _treasury;
    }

    function claim() external {
        require(!hasClaimed[msg.sender], "Already claimed");
        hasClaimed[msg.sender] = true;
        totalClaims += 1;
        require(token.transferFrom(treasury, msg.sender, CLAIM_AMOUNT), "Transfer failed");
        emit Claimed(msg.sender, CLAIM_AMOUNT);
    }
}
