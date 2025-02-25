// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Votes} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract FutureToken is ERC20, ERC20Votes, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC20("FutureToken", "FUT") ERC20Votes() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        // _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    function distributeTokens(
        address[] memory recipients,
        uint256[] memory amounts
    ) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "FutureToken: must have admin role to distribute tokens"
        );
        require(
            recipients.length == amounts.length,
            "FutureToken: recipients and amounts length mismatch"
        );

        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], amounts[i]);
        }
    }

    function mint(address to, uint256 amount) public {
        require(
            hasRole(MINTER_ROLE, msg.sender),
            "FutureToken: must have minter role to mint"
        );
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(
        address account,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }
}
