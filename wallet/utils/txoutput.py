#!/usr/bin/env python
# -*- coding:utf-8 -*-


class TxOutput:

    def __init__(self, value, address, shield_pkey=None, value_encrypt=None):
        self.value = value
        self.pub_key_hash = address
        self.shield_pkey = shield_pkey
        self.value_encrypt = value_encrypt

    def is_locked_with(self, pub_key_hash):
        return self.pub_key_hash == pub_key_hash
