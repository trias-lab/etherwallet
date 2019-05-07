#!/usr/bin/env python
# -*- coding:utf-8 -*-
import hashlib
import json
import time

from .txinput import TxInput
from .txoutput import TxOutput


class Transaction:
    def __init__(self, ID, vin, vout, timestamp=None):
        self.ID = ID
        self.Vin = vin
        self.Vout = vout
        if timestamp:
            self.timestamp = timestamp
        else:
            self.timestamp = int(round(time.time() * 1000))

    def is_coinbase(self):
        is_base = False
        try:
            is_base = len(self.Vin) == 1 and len(self.Vin[0].tx_id) == 0 and self.Vin[0].tx_output_index == -1
        except Exception as e:
            print(e)
        return is_base

    def serialize(self):
        vins = []
        vouts = []
        try:
            for vin in self.Vin:
                k = dict()
                k['tx_id'] = vin.tx_id
                k['tx_output_index'] = vin.tx_output_index
                k['signature'] = vin.signature
                k['address'] = vin.address
                k['pub_key'] = vin.pub_key
                vins.append(k)

            for vout in self.Vout:
                k = dict()
                k['value'] = vout.value
                k['shield_pkey'] = vout.shield_pkey
                k['pub_key_hash'] = vout.pub_key_hash
                vouts.append(k)
        except Exception as e:
            print(e)

        data = {
            "ID": self.ID,
            "Vin": vins,
            "Vout": vouts,
            "timestamp": self.timestamp
        }

        return json.dumps(data, sort_keys=True)

    def hash(self):
        tx_hash = ""
        try:
            tx_hash = hashlib.new('ripemd160', self.serialize().encode('utf-8')).hexdigest().upper()
            self.ID = tx_hash
        except Exception as e:
            print(e)
        return tx_hash

    def trimmed_copy(self):
        tx_inputs = []
        tx_outputs = []
        try:
            for vin in self.Vin:
                tx_in = TxInput(vin.tx_id, vin.tx_output_index, "",  "", "")
                tx_inputs.append(tx_in)

            for vout in self.Vout:
                tx_out = TxOutput(vout.value, vout.pub_key_hash, vout.shield_pkey)
                tx_outputs.append(tx_out)
        except Exception as e:
            print(e)

        tx_copy = Transaction(self.ID, tx_inputs, tx_outputs, self.timestamp)
        return tx_copy

