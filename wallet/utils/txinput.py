#!/usr/bin/env python
# -*- coding:utf-8 -*-

class TxInput:

    def __init__(self, tx_id, tx_output_index, signature, address, pub_key=""):
        self.tx_id = tx_id
        self.tx_output_index = tx_output_index
        self.signature = signature
        self.address = address
        self.pub_key = pub_key

    def uses_address(self, address):
        return self.pub_key == address
