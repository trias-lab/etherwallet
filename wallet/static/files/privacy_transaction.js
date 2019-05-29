
function TxInput(tx_id, tx_output_index, signature, address, pub_key) {
    this.tx_id = tx_id;
    this.tx_output_index = tx_output_index;
    this.signature = signature;
    this.address = address;
    this.pub_key = pub_key
}

function TxOutput(value, shield_addr, shield_pkey) {
    this.value = value;
    this.shield_addr = shield_addr;
    this.shield_pkey = shield_pkey;
}

function Transaction(ID, vin, vout, timestamp) {
    this.ID = ID;
    this.Vin = vin;
    this.Vout = vout;
    if (timestamp) {
        this.timestamp = timestamp;
    } else {
        this.timestamp = parseInt(new Date().getTime());
    }
}

Transaction.prototype.getSignedID = function(tx_copy, fromAddress, index) {
    for(var i=0; i<=index; i++) {
        tx_copy.Vin[i].signature = "";
        tx_copy.Vin[i].pub_key = "";
        tx_copy.Vin[i].address = "";
    }
    tx_copy.Vin[index].address = fromAddress;
    tx_copy.hash()
    return tx_copy.ID;
}


Transaction.fromString = function(s) {
    var obj = JSON.parse(s)
    var ret = {};
    ret.ID = obj.ID;
    ret.timestamp = obj.timestamp;
    ret.Vin = []
    for(i=0; i<obj.Vin.length; i++) {
        var vin = obj.Vin[i];
        var retVin = new TxInput(vin.tx_id, vin.tx_output_index, vin.signature, vin.address, vin.pub_key);
        ret.Vin.push( retVin )
    }
    ret.Vout = []
    for(i=0; i<obj.Vout.length; i++) {
        var vout = obj.Vout[i];
        var retVout = new TxOutput(vout.value, vout.pub_key_hash, vout.shield_pkey);
        ret.Vout.push( retVout )
    }
    return ret;
}


Transaction.prototype.is_coinbase = function() {
    var is_base = false;
    if (this.Vin.length === 1 &&
        this.Vin[0].tx_id === 0 &&
        this.Vin[0].tx_output_index === -1) {
        is_base = true;
    }
    return is_base;
}

Transaction.prototype.serialize = function() {
    var vins = [];
    var vouts = [];
    var k;
    var i;
    var vin;
    var vout;
    for(i=0; i<this.Vin.length; i++) {
        vin = this.Vin[i];
        k = {};
        k['tx_id'] = vin.tx_id;
        k['tx_output_index'] = vin.tx_output_index;
        k['signature'] = vin.signature;
        k['address'] = vin.address;
        k['pub_key'] = vin.pub_key;
        vins.push( k );
    }
    for(i=0; i<this.Vout.length; i++) {
        vout = this.Vout[i];
        k = {};
        k['value'] = vout.value;
        k['pub_key_hash'] = vout.shield_addr;
        k['shield_pkey'] = vout.shield_pkey;
        vouts.push( k );
    }
    var data = {
        "ID": this.ID,
        "Vin": vins,
        "Vout": vouts,
        "timestamp": this.timestamp
    }
    //var buffer = JSON.stringify(data);
    var buffer = sortedJsonStringify(data)
    buffer = buffer.replace(/:/g, ": ");
    buffer = buffer.replace(/,/g, ", ");
    //buffer = buffer.replace(/"/g, "'");
    return buffer;
}

Transaction.prototype.hash = function() {
    var tx_hash = "";
    var plain = this.serialize();
    //console.log('plain ' + plain);
    if (typeof process !== "undefined") {
        const crypto = require('crypto');
        var ripemd160 = crypto.createHash('ripemd160');
        ripemd160.update(plain);
        tx_hash = ripemd160.digest('hex');
        tx_hash = tx_hash.toUpperCase();
    } else {
        var hasher = CryptoApi.getHasher('ripemd160');
        hasher.update( plain );
        tx_hash = CryptoApi.encoder.toHex(hasher.finalize()).toUpperCase();
    }
    console.log('plain ' + plain);
    //console.log('hash ' + tx_hash);

    this.ID = tx_hash;
    return tx_hash;
}

Transaction.hashObj = function(obj) {
    var tx_hash = "";
    var plain = Transaction.prototype.serialize.call(obj);
    //console.log('plain ' + plain);
    if (typeof process !== "undefined") {
        const crypto = require('crypto');
        var ripemd160 = crypto.createHash('ripemd160');
        ripemd160.update(plain);
        tx_hash = ripemd160.digest('hex');
        tx_hash = tx_hash.toUpperCase();
    } else {
        var hasher = CryptoApi.getHasher('ripemd160');
        hasher.update( plain );
        tx_hash = CryptoApi.encoder.toHex(hasher.finalize()).toUpperCase();
    }
    //console.log('hash ' + tx_hash);

    obj.ID = tx_hash;
    return obj;
}

Transaction.prototype.trimmed_copy = function() {
    var tx_inputs = [];
    var tx_outputs = [];
    var vin, vout;
    var tx_in, tx_out;
    for(let i=0; i<this.Vin.length; i++) {
        vin = this.Vin[i];
        tx_in = new TxInput(vin.tx_id, vin.tx_output_index, "", "", "");
        tx_inputs.push( tx_in );
    }
    for(let i=0; i<this.Vout.length; i++) {
        vout = this.Vout[i];
        tx_out = new TxOutput(vout.value, vout.shield_addr, vout.shield_pkey);
        tx_outputs.push( tx_out );
    }
    var tx_copy = new Transaction(this.ID, tx_inputs, tx_outputs, this.timestamp);
    return tx_copy;
}

/*
var getSignedID = function(tx_copy, index) {
    for(let i=0; i<=index; i++) {
        tx_copy.Vin[i].signature = "";
    }
    tx_copy.hash()
    return tx_copy.ID;
}
*/

var sortedJsonStringify = function (obj, opts) {
    var isArray = Array.isArray || function (x) {
        return {}.toString.call(x) === '[object Array]';
    };

    var objectKeys = Object.keys || function (obj) {
        var has = Object.prototype.hasOwnProperty || function () { return true };
        var keys = [];
        for (var key in obj) {
            if (has.call(obj, key)) keys.push(key);
        }
        return keys;
    };

    if (!opts) opts = {};
    if (typeof opts === 'function') opts = { cmp: opts };
    var space = opts.space || '';
    if (typeof space === 'number') space = Array(space+1).join(' ');
    var cycles = (typeof opts.cycles === 'boolean') ? opts.cycles : false;
    var replacer = opts.replacer || function(key, value) { return value; };

    var cmp = opts.cmp && (function (f) {
        return function (node) {
            return function (a, b) {
                var aobj = { key: a, value: node[a] };
                var bobj = { key: b, value: node[b] };
                return f(aobj, bobj);
            };
        };
    })(opts.cmp);

    var seen = [];
    return (function stringify (parent, key, node, level) {
        var indent = space ? ('\n' + new Array(level + 1).join(space)) : '';
        var colonSeparator = space ? ': ' : ':';

        if (node && node.toJSON && typeof node.toJSON === 'function') {
            node = node.toJSON();
        }

        node = replacer.call(parent, key, node);

        if (node === undefined) {
            return;
        }
        if (typeof node !== 'object' || node === null) {
            return JSON.stringify(node);
        }
        if (isArray(node)) {
            var out = [];
            for (var i = 0; i < node.length; i++) {
                var item = stringify(node, i, node[i], level+1) || JSON.stringify(null);
                out.push(indent + space + item);
            }
            return '[' + out.join(',') + indent + ']';
        }
        else {
            if (seen.indexOf(node) !== -1) {
                if (cycles) return JSON.stringify('__cycle__');
                throw new TypeError('Converting circular structure to JSON');
            }
            else seen.push(node);

            var keys = objectKeys(node).sort(cmp && cmp(node));
            var out = [];
            for (var i = 0; i < keys.length; i++) {
                var key = keys[i];
                var value = stringify(node, key, node[key], level+1);

                if(!value) continue;

                var keyValue = JSON.stringify(key)
                    + colonSeparator
                    + value;
                ;
                out.push(indent + space + keyValue);
            }
            seen.splice(seen.indexOf(node), 1);
            return '{' + out.join(',') + indent + '}';
        }
    })({ '': obj }, '', obj, 0);
};


if (typeof process !== "undefined") {
    module.exports.Transaction = Transaction;
    module.exports.TxInput = TxInput;
    module.exports.TxOutput = TxOutput;
}

