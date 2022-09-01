<script>
    import {ethers} from 'ethers';
    export let web3Props = { 
        provider: null, 
        signer: null, 
        account: null, 
        chainId: null, 
        contract: null 
    };

    async function Mint() {
        web3Props.contract.requestNft({
            gasLimit: 100000
        });
    }
</script>

<div class='wrapper'>
    <button on:click={Mint}>Mint An NFT</button>
</div>