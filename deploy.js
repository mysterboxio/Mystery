// The deployment script
const main = async () => {
    // Getting the first signer as the deployer
    const [deployer] = await ethers.getSigners();
    // Saving the info to be logged in the table (deployer address)
    var deployerLog = { Label: "Deploying Address", Info: deployer.address };
    // Saving the info to be logged in the table (deployer address)
    var deployerBalanceLog = { 
        Label: "Deployer ETH Balance", 
        Info: (await deployer.getBalance()).toString() 
    };

    // Creating the instance and contract info for the MYSTLottery contract
    let MYSTLotteryInstance, MYSTLotteryContract;

    // Getting the MYSTLottery contract code (abi, bytecode, name)
    MYSTLotteryContract = await ethers.getContractFactory("MYSTLottery");

    // Deploys the contracts
    MYSTLotteryInstance = await MYSTLotteryContract.deploy();
    await MYSTLotteryInstance.deployed();

    // Saving the info to be logged in the table (deployer address)
    var MYSTLotteryLog = { Label: "Deployed MYSTLottery contract Address", Info: MYSTLotteryInstance.address };

    console.table([
        deployerLog, 
        deployerBalanceLog,
        MYSTLotteryLog
    ]);
}
// Runs the deployment script, catching any errors
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
  });