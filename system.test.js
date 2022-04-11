require("@nomiclabs/hardhat-ethers");
const { expect, assert } = require("chai");
const { network, ethers } = require("hardhat");
const {BigNumber} = require("ethers");
const strongABI = require("./abi/strongABI.json")

describe("SNN Contract", function() {
    
    const provider = new ethers.providers.JsonRpcProvider("https://eth-mainnet.alchemyapi.io/v2/7Y3S0owAhDkReWeYK6JhprEbCX-zmDX4");

    let owner, buyer;
    let strongAddress = "0x990f341946a3fdb507ae7e52d17851b87168017c";
    let account1 = "0xd3019915a2dd19fc3db60155ae7e71a6378a882d";
    let account2 = "0xe2f071Fa6a421c6Bd7DF3635cC001c569182B950";
    
    it("Test", async function () {
        await network.provider.request({
            method: "hardhat_impersonateAccount",
            params: [account1],
          });

        // await provider.send('hardhat_impersonateAccount', [account1]);
        const signer = await ethers.provider.getSigner(account1)
        var log1 = { 
            Label: 'signer', 
            Info: signer
        };

        const strongContract = new ethers.Contract(strongAddress, strongABI, provider)
        let strongBalance = await strongContract.balanceOf(account1)
        var log2 = { 
            Label: `strong balance of account1`, 
            Info: BigNumber.from(strongBalance).div(BigNumber.from(10).pow(18)).toString()
        };

        // strongBalance = await strongContract.balanceOf(account2)
        // var log3 = { 
        //     Label: `strong balance of account2`, 
        //     Info: BigNumber.from(strongBalance).div(BigNumber.from(10).pow(18)).toString()
        // };

        await strongContract.connect(signer).transfer(account2, strongBalance)
        // strongBalance = await strongContract.balanceOf(account2)
        // var log4 = { 
        //     Label: `strong balance of account2`, 
        //     Info: BigNumber.from(strongBalance).div(BigNumber.from(10).pow(18)).toString()
        // };

        console.table([
            log1,
            log2,
            // log3,
            // log4
        ]);
    });

    beforeEach(async () => {
        // Getting the signers provided by ethers
        const [signers] = await ethers.getSigners();
        // Creating the active wallets for use
        owner = signers[0];
        buyer = signers[1];
    });
});
