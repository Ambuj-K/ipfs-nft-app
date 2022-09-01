#!/usr/bin/env bash

# Read the RPC URL
echo Enter Your RPC URL:
echo Example: "https://eth-goerli.alchemyapi.io/v2//XXXXXXXXXX"
read -s rpc

# Read the contract name
echo Which contract do you want to deploy \(eg Greeter\)?
read contract

forge create ./src/${contract}.sol:${contract} -i --rpc-url $rpc --constructor-args "0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D" "869" "0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15" "2500000" """[ "ipfs://QmYgb3tawCnMGPMV4DGFawNznEBzoFNXsZNwvTPDB4mZxc","ipfs://QmRAakxqsTJqGAhd5yd3iip4fEL7KMZanTaxLH9k2wHqND","ipfs://Qmc6qfwny924kLWfoxKpA3VsauFKnBUecm8912RM1DfJbe"]""" "50000000"