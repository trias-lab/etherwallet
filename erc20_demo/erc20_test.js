
//是否是测试
const IS_TEST = true
let provider;
var ContractAddress;
if (IS_TEST) {
    //测试配置
    provider = ethers.getDefaultProvider('ropsten');
    ContractAddress = "0xe906c9fa6c5239e9ea8a9bb2ff656e146ff5142c"
} else {
    //正式配置
    provider = ethers.getDefaultProvider('mainnet');
    //TRY 币合约地址 https://etherscan.io/token/0xe431a4c5db8b73c773e06cf2587da1eb53c41373
    ContractAddress = "0xe431a4c5db8b73c773e06cf2587da1eb53c41373"
}

//全局合约对象
const contract = new ethers.Contract(ContractAddress, erc20_abi, provider);

//当前地址
var currentAddress = "0x10aAE3635324ED530b5399984552a020E6D2cD77"
//当前地址的私钥
var currentPrivateKey = "0xF870324C0845326903C705C7AD980A35CA40B2E8772666F3BD9A216800586138"

//etherscan api key
const ETHERSCAN_API_KEY = "Y5BJ5VA3XZ59F63XQCQDDUWU2C29144MMM"


function getExplorerTxLink(txHash) {
    var url
    if (IS_TEST) {
        url = "https://ropsten.etherscan.io/tx/" + txHash
    } else {
        url = "https://etherscan.io/tx/" + txHash
    }
    return url
}

function getEtherscanHistory(address, callback) {
    var url;
    if (IS_TEST) {
        url = "https://api-ropsten.etherscan.io"
    } else {
        url = "https://api.etherscan.io"
    }
    url += "/api?module=account&action=tokentx&address="
    url += address
    url += "&contractaddress=" + ContractAddress
    url += "&startblock=0&endblock=999999999&sort=desc&apikey="
    url += ETHERSCAN_API_KEY

    console.log("history url = " + url)
    var ajax = new XMLHttpRequest();
    ajax.open("GET", url, true);
    ajax.send();
    ajax.onreadystatechange = function () {
        if (ajax.readyState == 4) {
            if(ajax.status != 200){
                alert('查询历史记录失败')
                return;
            }
            console.log("history response: " + ajax.responseText)
            var ret = JSON.parse(ajax.responseText);
            if (ret.message !== "OK") {
                alert('查询历史记录失败:' + ret.message)
                return;
            }
            var array = ret.result;
            return callback(array)
        }
    }
}


function timestampToDateString(timestamp) {
    var date = new Date(timestamp);
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    return year + "-" + (month < 10 ? "0" + month : month) + "-" + (day < 10 ? "0" + day : day) + " " + date.toTimeString().substr(0, 8);
}

function refreshBalance() {
    (async function() {
        var balance =  await contract.balanceOf(currentAddress);
        balance = parseFloat(balance)/ 10**18
        document.getElementById("currentBalanceId").innerHTML  = "TRY余额： " + balance;
    })();
}


function sendTRY() {
    (async function() {
        var amount = parseInt(document.getElementById("sendAmountId").value);
        var toAddress = document.getElementById("receiveAddressId").value;

        var wallet = new ethers.Wallet(currentPrivateKey, provider);
        let contractWithSigner = contract.connect(wallet);
        amount = ethers.utils.parseUnits(amount.toString(), 18)
        let tx = await contractWithSigner.transfer(toAddress, amount);
        console.log("tx hash is " + tx.hash);
        document.getElementById("transactionLinkId").innerHTML  = '<a href="' + getExplorerTxLink(tx.hash) + '" target="_blank">查看交易详情</a>'
    })();
}

function  getTRYHistory() {
    getEtherscanHistory(currentAddress, function (historyArray) {
        var s = ""

        //删除之前的记录，重新添加
        var table = document.getElementById("transactionHistoryTableId")
        var first = table.getElementsByTagName('tr')[0];
        while (table.hasChildNodes()) {
            table.removeChild(table.lastChild);
        }
        table.appendChild(first)

        for(var i=0; i<historyArray.length; i++) {
            var item = historyArray[i];
            var seq = i+1
            var type
            if (item.from.toLowerCase() === currentAddress.toLowerCase() && item.to.toLowerCase() === currentAddress.toLowerCase()) {
                type = "移动"
            } else if (item.from.toLowerCase() === currentAddress.toLowerCase()) {
                type = "发送"
            } else if (item.to.toLowerCase() === currentAddress.toLowerCase()) {
                type = "接收"
            } else {
                console.log("history is not mine, " + item)
                continue
            }
            var amount = parseFloat(item.value) / 10**18
            var time = timestampToDateString(parseInt(item.timeStamp) * 1000)
            var hash = item.hash
            var link = '<a href="' + getExplorerTxLink(hash) + '" target="_blank">' + hash + '</a>'

            var tr = document.createElement("tr");
            //序号
            var td = document.createElement("td");
            td.innerHTML = seq.toString()
            tr.appendChild(td);
            //类型
            td = document.createElement("td");
            td.innerHTML = type
            tr.appendChild(td);
            //金额
            td = document.createElement("td");
            td.innerHTML = amount.toString()
            tr.appendChild(td);
            //日期
            td = document.createElement("td");
            td.innerHTML = time
            tr.appendChild(td);
            //交易ID
            td = document.createElement("td");
            td.innerHTML = link
            tr.appendChild(td);

            table.appendChild(tr);
        }
    })
}


function init() {
    document.getElementById("currentAddressId").innerHTML = "当前地址：" + currentAddress;
    refreshBalance();
}

init()
