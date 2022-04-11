// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

/**
 * @title MYSTLottery contract
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
 */

contract MYSTLottery is Ownable {
    address public constant MYST = 0xCdcaef3cE3a138C47ddB0B04a9b04649c13D50Ed;
    address public MYSTBox;

    mapping (uint256 => uint256) public prizeMYST;
    mapping (uint256 => bool) public prizeRedeemState;
    uint256[] public winnerInfo;

    bool public prizeRedeemEnable;
    bool public raffleDone;
    
    uint256 public prizeCount = 500;

    
    constructor() {
        prizeMYST[0] = 15000 * 10 ** 9;
        prizeMYST[1] = 50000 * 10 ** 9;
        prizeMYST[2] = 100000 * 10 ** 9;
        prizeMYST[3] = 200000 * 10 ** 9;
        prizeMYST[4] = 300000 * 10 ** 9;
        prizeMYST[5] = 400000 * 10 ** 9;
        prizeMYST[6] = 500000 * 10 ** 9;
        prizeMYST[7] = 1000000 * 10 ** 9;
        prizeMYST[8] = 1500000 * 10 ** 9;
        prizeMYST[9] = 2000000 * 10 ** 9;
    }

    function updatePrize(uint8 grade, uint256 prizeAmount) external onlyOwner {
        require(grade < 10, "there are total 10 grades.");
        require(prizeAmount >= 15000 * 10 ** 9, "prize should be grater than 15k MYST at least");
        prizeMYST[grade] = prizeAmount;
    }

    function updatePrizeCount(uint256 newPrizeCount) external onlyOwner {
        prizeCount = newPrizeCount;
    }

    function updatePrizeRedeemEnable(bool flag) external onlyOwner {
        prizeRedeemEnable = flag;
    }

    function updateMYSTBox(address _MYSTBox) external onlyOwner {
        MYSTBox = _MYSTBox;
    }

    function setBaseData(uint256[] memory baseData) external onlyOwner {
        require(winnerInfo.length == 0, "base data already set.");
        require(baseData.length == prizeCount, "base data not matched with prize count");

        for (uint256 i=0; i<prizeCount; i++)
            winnerInfo.push(baseData[i]);
    }

    function raffle() external onlyOwner {
        require(!raffleDone, "finished raffle already.");
        
        raffleDone = true;

        uint256 tempLength = prizeCount;

        for (uint256 i = 0; i < prizeCount; i++) {
            uint256 rand = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender, winnerInfo[i]))) % tempLength;
            uint256 temp = winnerInfo[rand];
            winnerInfo[rand] = winnerInfo[tempLength - 1];
            winnerInfo[tempLength - 1] = temp;
            tempLength = tempLength - 1;
        }
    }

    function prizeRedeem(uint256 ticketId) external {
        require(raffleDone, "raffle not finished yet");
        require(prizeRedeemEnable, "reedem not enabled yet.");
        require(!prizeRedeemState[ticketId], "This ticket already redeemed prize.");
        require(IERC721(MYSTBox).ownerOf(ticketId) == msg.sender, "Not owner of ticket.");
        
        prizeRedeemState[ticketId] = true;
        IERC20(MYST).transfer(msg.sender, prizeMYST[winnerInfo[ticketId]]);
    }

    /**
     * withdraw
     */
    function withdrawMYST() public onlyOwner {
        IERC20(MYST).transfer(msg.sender, IERC20(MYST).balanceOf(address(this)));
    }
}