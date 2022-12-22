// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/*
              _____ ____      _    ____ _____ 
             |_   _|  _ \    / \  / ___| ____|   
               | | | |_) |  / _ \| |   |  _|  
               | | |  _ <  / ___ \ |___| |___ 
               |_| |_| \_\/_/   \_\____|_____| 
    .-"^`\                                        /`^"-.
  .'   ___\                                      /___   `.
 /    /.---.                                    .---.\    \
|    //     '-.  ___________________________ .-'     \\    |
|   ;|         \/--------------------------//         |;   |
\   ||       |\_)           TRACE          (_/|       ||   /
 \  | \  . \ ;  |           Token          || ; / .  / |  /
  '\_\ \\ \ \ \ |                          ||/ / / // /_/'
        \\ \ \ \|            TRC           |/ / / //
         `'-\_\_\       5 000 000 000      /_/_/-'`
                '--------------------------'
*/ 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract TRC is ERC20, ERC20Burnable, Pausable, AccessControl, ERC20Permit {

    constructor()
        ERC20("Trace Governance Token", "TRC") 
        ERC20Permit("Trace Governance Token")
    {
        _mint(msg.sender, 5_000_000_000 * 10 ** decimals());
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function pause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20)
    {
        super._burn(account, amount);
    }

    function decimals() public view virtual override returns (uint8) {
        return 2;
    }
}