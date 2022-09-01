<script>
    import WalletConnect from "../lib/WalletConnect.svelte";
    import MintIPFSNft from "../lib/MintIPFSNft.svelte";
    import contractAbi from "../contracts/IPFSNft.json";
    const contractAddr =  "0xcD9E77d94e4AB966EFa76c5dE3C4DcdB32B57051";
    export let web3Props = {
        provider : null,
        signer : null,
        account : null,
        chainId : null
    };
</script>

<div class="OUTER">
<h1>Welcome to NFT Minting</h1>
</div>
{#if !web3Props.account}
<WalletConnect bind:web3Props {contractAddr} {contractAbi} />
{:else}
<MintIPFSNft bind:web3Props/>
{/if}

<style>
    .OUTER {
        border-radius: 15px;
        padding: 20px;
        overflow: hidden;
        position: relative;
        background-color: blueviolet;
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
    }
</style>