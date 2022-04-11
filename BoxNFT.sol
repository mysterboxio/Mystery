// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import './ERC721A.sol';

/**
 * @title MYSTBox contract
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
 */

contract MYSTBox is Ownable, ERC721A {
    address public constant MYST = 0xCdcaef3cE3a138C47ddB0B04a9b04649c13D50Ed;
    
    uint256 public maxSupply = 500;
    uint32 public saleStartTime = 0;
    uint256 public ticketPrice = 100000 * 10 ** 9;

    mapping(address => uint256) public lastBuyTime;

    uint256 public buyCoolDown = 60 seconds;

    constructor() ERC721A("MYST Box 1", "MYSTBox1") {}

    function setTicketPrice(uint256 newTicketPrice) external onlyOwner {
        ticketPrice = newTicketPrice;
    }

    function setMaxSupply(uint newMaxSupply) public onlyOwner {
        maxSupply = newMaxSupply;
    }

    function setSaleStartTime(uint32 newTime) public onlyOwner {
        saleStartTime = newTime;
    }

    function setBuyCoolDown(uint256 newBuyCoolDown) external onlyOwner {
        buyCoolDown = newBuyCoolDown;
    }

    /**
     * metadata URI
     */
    string private _baseURIExtended = "";

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseURIExtended = baseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIExtended;
    }

    /**
     * Get the array of token for owner.
     */
    function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);
        if (tokenCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            for (uint256 index; index < tokenCount; index++) {
                result[index] = tokenOfOwnerByIndex(_owner, index);
            }
            return result;
        }
    }

    function buyTicket() external {
        require(msg.sender == tx.origin, "User wallet required");
        require(saleStartTime != 0 && saleStartTime <= block.timestamp, "sales is not started");
        require(totalSupply() < maxSupply, "ticket sold out.");
        require(block.timestamp - lastBuyTime[msg.sender] >= buyCoolDown, "need to wait more.");

        lastBuyTime[msg.sender] = block.timestamp;

        IERC20(MYST).transferFrom(msg.sender, address(this), ticketPrice);
        _safeMint(msg.sender, 1);
    }

    /**
     * withdraw
     */
    function withdrawMYST() public onlyOwner {
        IERC20(MYST).transfer(msg.sender, IERC20(MYST).balanceOf(address(this)));
    }
}