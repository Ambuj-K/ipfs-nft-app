<script>
    import {ethers} from 'ethers';
    export let web3Props = { 
        provider: null, 
        signer: null, 
        account: null, 
        chainId: null, 
        contract: null 
    };

    $: NFTs = null;

    async function Mint() {
        NFTs = await web3Props.contract.requestNft({
            value: 60000000,
            gasLimit: 100000
        });
        web3Props.contract.on("requestedNFT", (addr) => { 
            
        });
    }
</script>

<div class='wrapper'>
    {#if !NFTs}
    <button on:click={Mint}>Mint An NFT</button>
    {:else}
    RequestID: {NFTs}
    {/if}
</div>