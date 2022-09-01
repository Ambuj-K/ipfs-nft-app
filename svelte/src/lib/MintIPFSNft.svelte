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
    $: image_url = null;
    $: status = null;

    async function Mint() {
        await web3Props.contract.requestNft({
            value: 60000000,
            gasLimit: 100000
        });
        web3Props.contract.on("requestedNFT", async (request_id,addr) =>  {
            status="Loading..."
        });
        web3Props.contract.on("mintedNFT", async (uri_no,addr) =>  { 
           NFT_json = await web3Props.contract.artURIsGetter(uri_no);
           const response = await fetch("https://api.ipfsbrowser.com/ipfs/get.php?hash="+NFT_json.split("//")[1]);
           const data = await response.json();
           image_url = "https://api.ipfsbrowser.com/ipfs/get.php?hash="+String(data.image).split("//")[1];
           status = "LOADED";
        });
    }
</script>

<div class='wrapper'>
    {#if !NFT_json}
    <button class='bttn' on:click={Mint}>Mint An NFT</button>
    <br/>
    {:else if status=="Loading..."}
    {status}
    <br/>
    {:else}
    {status}
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
        width: 500px;
        height: 500px;
    }
</style>