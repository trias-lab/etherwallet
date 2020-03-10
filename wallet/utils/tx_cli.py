#!/usr/bin/env python
# -*- coding:utf-8 -*-

import json
import base64
import requests

from .transaction import Transaction
from .txinput import TxInput
from .txoutput import TxOutput

SUBSIDY = int(100*1e18)

def new_coinbase_tx(to_address):
    txin = TxInput("", -1, None, "www.trias.one", "try")
    txout = TxOutput(SUBSIDY, to_address)
    tx = Transaction(None, [txin], [txout])
    tx.hash()

    return tx

def new_keyValue_tx(value):
    txin = TxInput("", -1, None, "0", "0")
    txout = TxOutput(1, value)
    tx = Transaction(None, [txin], [txout])
    tx.hash()

    return tx

def new_utxo_transaction(from_address, to_address, amount, accumulated, unspent_outs):
    if (not accumulated) or (accumulated < int(amount)):
       return None

    try:
        total = 0
        tx_inputs = []
        for tx_id in unspent_outs.keys():
            for vout in unspent_outs[tx_id]:
                tx_input = TxInput(tx_id, vout.index, "", from_address, from_address)
                tx_inputs.append(tx_input)
                total += int(vout.value)
                if total >=  int(amount):
                    break
            if total >= int(amount):
                break

        if total < int(amount):
            return None

        tx_outputs = []
        tx_out = TxOutput(int(amount), to_address)
        tx_outputs.append(tx_out)

        if total > int(amount):
            tx_outputs.append(TxOutput(total - int(amount), from_address))

        tx = Transaction(None, tx_inputs, tx_outputs)
        tx.hash()
        result = tx

    except Exception as e:
        result = None

    return result


def json_to_tx(tx):
    vins = []
    for vin in tx['Vin']:
        tx_in = TxInput(vin['tx_id'], vin['tx_output_index'], vin['signature'], vin['address'], vin['pub_key'])
        vins.append(tx_in)

    vouts = []
    for vout in tx['Vout']:
        tx_out = TxOutput(vout['value'], vout['pub_key_hash'], vout['shield_pkey'])
        vouts.append(tx_out)

    transaction = Transaction(tx['ID'], vins, vouts, tx['timestamp'])

    return transaction
