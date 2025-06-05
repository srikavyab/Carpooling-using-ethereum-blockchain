web3.eth.getBalance(hashcode).then(function (rvalue) {
    rvalue = web3.utils.fromWei(rvalue, "ether");
    console.log(rvalue);
    $("#balance").html(rvalue + "ETH");

})