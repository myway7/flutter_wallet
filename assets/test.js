function test(){
    Toast.postMessage("JS调用了Flutter");
    return new Promise(
        function(resolve,reject){
            window.getKeyStore =  resolve

        }
    )
}
getKeyStoreCallBack = {
    resolve:function(params) {
        getKeyStore(params)
    }
}

window.native = {
 test,
 getKeyStoreCallBack
}