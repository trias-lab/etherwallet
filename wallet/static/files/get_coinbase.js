
const COIN_BASE_AMOUNT = 100*1e18

triacc = new Object();  //必需在使用trias_wasm.wasm的页面进行triacc对象的初始化
if (!WebAssembly.instantiateStreaming) { // polyfill
    WebAssembly.instantiateStreaming = async (resp, importObject) => {
        const source = await (await resp).arrayBuffer();
        return await WebAssembly.instantiate(source, importObject);
    };
}

const go = new Go();
let mod, inst;
var rss, currentaddr, curPrivA;
var wasmUrl = "/api/files/triacc_wasm.wasm"
WebAssembly.instantiateStreaming(fetch(wasmUrl), go.importObject).then((result) => {
    mod = result.module;
    inst = result.instance;
    go.run(inst);
    //alert("Load wasm file succ!")
    console.log('Load wasm file succ!')
    setTimeout(function () {
        CreateAcc();
    }, 1)
    //document.getElementById("runButton").disabled = false;
});


//创建账号
function CreateAcc() {
    var password = "1234qwer";
    triacc.CreateAcc(password, function (rs) {
        //console.log('rs:' + rs)
        rss = rs
        triacc.Load4Data(rss, password, function () {
            console.log("load acc from data succ")
            triacc.GetCurrentAcc(function (addr) {
                currentaddr = addr
                //console.log('addr:' + addr)
                setTimeout(function () {
                    triacc.GetPrivkeyA(function (privA) {
                        curPrivA=privA
                        //console.log('curPrivA: ' + curPrivA)
                        afterCreateAcc();
                    })
                }, 0)
            });
        });
    })
}


//账号文件打开以后
function afterCreateAcc() {
    setVisible("get_coinbase_content", true);
    setVisible('loading_content', false);
}

//生成隐私矿工交易对象
function new_privacy_coinbase_tx(to_shield_addr, to_shield_pkey) {
    var txin = new TxInput("", -1, "", "www.8lab.cn", "www.trias.one")
    var txout = new TxOutput(COIN_BASE_AMOUNT, to_shield_addr, to_shield_pkey)
    var tx = new Transaction("", [txin], [txout])
    tx.hash()
    return tx
}

//生成明文矿工交易对象
function new_normal_coinbase_tx(to_address) {
    var txin = new TxInput("", -1, "", "www.8lab.cn", "www.trias.one")
    var txout = new TxOutput(COIN_BASE_AMOUNT, to_address, "")
    var tx = new Transaction("", [txin], [txout])
    tx.hash()
    return tx
}


//指定地址创建coinbase交易
function createCoinBaseTransactionWithAddress(toAddress, isPrivate, callback) {
    if (isPrivate) {
        triacc.CreateShieldAddr(toAddress, function (sdata) {
            //console.log('sdata', sdata)
            var saddrpkey=JSON.parse(sdata)
            if (!saddrpkey.Shieldaddr || !saddrpkey.Shieldaddr.length ||
                !saddrpkey.ShieldpKey || !saddrpkey.ShieldpKey.length)  {
                callback({result:'fail', message:'输入地址不正确'})
                return;
            }
            setTimeout(function () {
                var tx = new_privacy_coinbase_tx(saddrpkey.Shieldaddr, saddrpkey.ShieldpKey);
                var buffer = tx.serialize();
                buffer = buffer.replace(/"/g, "'");
                var txBuffer = encodeURIComponent(buffer);
                //console.log('txBuffer', txBuffer);
                sendCoinbase(txBuffer, tx.ID, callback)
            },0)
        });
    } else {
        var tx = new_normal_coinbase_tx(toAddress);
        var buffer = tx.serialize();
        buffer = buffer.replace(/"/g, "'");
        var txBuffer = encodeURIComponent(buffer);
        //console.log('txBuffer', txBuffer);
        sendCoinbase(txBuffer, tx.ID, callback)
    }
}

//发送交易接口
function sendCoinbase(transContent, txHash, callback) {
    ajax = new XMLHttpRequest();
    var url = "/api/newCoinbase";
    ajax.open("POST", url, true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send(transContent);
    ajax.onreadystatechange = function () {
        if (ajax.readyState == 4) {
            if (ajax.status == 200) {
                callback({result:'success', txHash:txHash})
            } else {
                callback({result:'fail', message:'发送交易失败'})
            }
        }
    }
}


function setVisible(elemId, visible) {
    if (visible) {
        if (document.getElementById(elemId))
            document.getElementById(elemId).style.display = "block";
    } else {
        if (document.getElementById(elemId))
            document.getElementById(elemId).style.display = "none";
    }
}

setVisible('get_coinbase_content', false);
setVisible('loading_content', true);
