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

    // Creating the instance and contract info for the MYSTBox contract
    let MYSTBoxInstance, MYSTBoxContract;

    // Getting the MYSTBox contract code (abi, bytecode, name)
    MYSTBoxContract = await ethers.getContractFactory("MYSTBox");

    // Deploys the contracts
    MYSTBoxInstance = await MYSTBoxContract.deploy();
    await MYSTBoxInstance.deployed();

    // Saving the info to be logged in the table (deployer address)
    var MYSTBoxLog = { Label: "Deployed MYSTBox contract Address", Info: MYSTBoxInstance.address };

    console.table([
        deployerLog, 
        deployerBalanceLog,
        MYSTBoxLog
    ]);
}
// Runs the deployment script, catching any errors
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
  });