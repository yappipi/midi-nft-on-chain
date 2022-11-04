const main = async () => {
    const [owner] = await hre.ethers.getSigners();
    const contractFactory = await hre.ethers.getContractFactory("SongStorage");
    const contract = await contractFactory.deploy();
    await contract.deployed();
    console.log("Contract deployed to:", contract.address);

    songs = await contract.getSongs();
    songs.forEach(_song => console.log(_song.tokenId + " : " + _song.name));    

    let txn = await contract.mint("#0", "body0");
    await txn.wait();
    console.log("Minted NFT #0");

    songs = await contract.getSongs();
    songs.forEach(_song => console.log(_song.tokenId + " : " + _song.name));    

    txn = await contract.mint("#1", "body1");
    await txn.wait();
    console.log("Minted NFT #1");

    songs = await contract.getSongs();
    songs.forEach(_song => console.log(_song.tokenId + " : " + _song.name));    

    txn = await contract.mint("#2", "body2");
    await txn.wait();
    console.log("Minted NFT #2");

    songs = await contract.getSongs();
    songs.forEach(_song => console.log(_song.tokenId + " : " + _song.name));    
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();
