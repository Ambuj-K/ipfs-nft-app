<script>
    import {ethers} from 'ethers';
    export let web3Props = { 
        provider: null, 
        signer: null, 
        account: null, 
        chainId: null, 
        contract: null 
    };

    $: NFT_json = null;
    $: request_id = null;
    $: image_url = null;
    $: status = "LOADING";

    async function Mint() {
        request_id = Number(await web3Props.contract.requestNft({
            value: 60000000,
            gasLimit: 100000
        }));
        web3Props.contract.on("mintedNFT", async (uri_no,addr) =>  { 
           NFT_json = await web3Props.contract.artURIsGetter(uri_no);
           const response = await fetch("https://api.ipfsbrowser.com/ipfs/get.php?hash="+NFT_json.split("//")[1]);
           const data = await response.json();
           console.log(data.image);
           image_url = "https://api.ipfsbrowser.com/ipfs/get.php?hash="+String(data.image).split("//")[1];
           status = "LOADED";
        });
    }
</script>

<div class='wrapper'>
    {#if !NFT_json}
    <button class='bttn' on:click={Mint}>Mint An NFT</button>
    {:else}
    RequestID: {request_id}
    <br/>
    {status}
    <br/>
    {#if image_url}
        <img class="image_div" src={image_url} alt="Loading..."/>
    {/if}
    {/if}
</div>

<style>
    .wrapper {
        border-radius: 5px;
        padding: 20px;
        overflow: hidden;
        position: relative;
        background-color: wheat;
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
    }
    .bttn{
        background-color: pink;
        text-decoration: aqua;
    }
    .image_div{
        background-color: wheat;
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
    }
</style>