-include .env

build : forge build

deploy-sepolia:
	forge script script/DeployFundMe.sol:DeployFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY