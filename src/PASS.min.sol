// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
 
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
 \  | \  . \ ;  |        Genesis NFT       || ; / .  / |  /
  '\_\ \\ \ \ \ |                          ||/ / / // /_/'
        \\ \ \ \|           Pass           |/ / / //
         `'-\_\_\         Unlimeted        /_/_/-'`
                '--------------------------'
*/ 

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.7.3/security/Pausable.sol";
import "@openzeppelin/contracts@4.7.3/access/AccessControl.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

contract TraceNFTPass is ERC721, ERC721Enumerable, Pausable, AccessControl {
    using Counters for Counters.Counter;

    event ChangeBaseURI(string indexed baseURI);

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    string private base;

    constructor() ERC721("Trace Genesis NFT Pass", "PASS") { // Trace Genesis NFT Pass
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function _baseURI() internal view override returns (string memory) {
        return base;
    }

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function changeBaseURI(string memory _base) public onlyRole(DEFAULT_ADMIN_ROLE) {
        base = _base;
        emit ChangeBaseURI(_base);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function safeMintBatch(address[] memory recipients, uint256[] memory amounts) public onlyRole(MINTER_ROLE) {
        require(recipients.length == amounts.length, "ERC721: recipients and amounts length mismatch");
        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            uint256 amount = amounts[i];
            for (uint256 j = 0; j < amount; j++) {
                safeMint(recipient);
            }
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
