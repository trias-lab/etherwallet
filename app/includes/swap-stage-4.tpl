<section class="swap-panel">


    <!-- <div class="alert alert-danger" ng-show="ajaxReq.type!=='ETH'">
        <strong>Warning! You are not connected to an ETH node.</strong> <br/> Please use the node switcher in the top-right
        corner to switch to an ETH node. We <strong>do not
        </strong> support swapping ETC or Testnet ETH.
    </div> -->

    <section class="" ng-show="!isKyberSwap " ng-controller='sendTxCtrl'>

    <!-- similar to sendTx-content.tpl --- START -->

        <!-- Sidebar -->
        <!-- <article class="row" ng-show="wallet!=null"> -->
        <section ng-show="wallet!=null && showStage3Eth && orderResult.progress.status=='OPEN' && wd">
            <div class="block block--danger" ng-show="wallet!=null && globalService.currentTab==globalService.tabs.swap.id && !hasEnoughBalance()">
                <h5 translate="SWAP_Warning_1">
                    Warning! You do not have enough funds to complete this swap.
                </h5>
                <p translate="SWAP_Warning_2">
                    Please add more funds to your wallet or access a different wallet.
                </p>
            </div>
            <wallet-balance-drtv></wallet-balance-drtv>
            <div ng-show="checkTxPage" ng-click="checkTxReadOnly=!checkTxReadOnly" class="small text-right text-gray-lighter">
                <small translate="X_Advanced">
                    Advanced Users Only.
                </small>
            </div>
        </section>
        <!-- </article> -->
        <!-- / Sidebar -->
        <!-- Content -->
        <div class="swap-panel">
            <div class="swap-panel-tit" ng-class="wallet!=null && hasEnoughBalance() && showStage3Eth && orderResult.progress.status=='OPEN' && wd ?'swap-panel-tit':'swap-panel-tit not-slect'">
                <div class="swap-pane-step">4</div>
                <span>Transaction Detail</span>
                <i class="fas fa-check-circle success" ng-show="showStage3Eth && orderResult.progress.status=='FILL'||orderResult.progress.status=='RCVE'"></i>
            </div>

            <!-- <article class="row" ng-show="wallet!=null"> -->
            <!-- If unlocked with address only -->

            <div class="swap-panel-warp" ng-show="wallet!=null && hasEnoughBalance() && showStage3Eth && orderResult.progress.status=='OPEN' && wd">
                <article class="block" ng-show="wallet.type=='addressOnly'">
                    <div class="row form-group">
                        <h4 translate="SEND_ViewOnly">
                            You cannot send with only your address. You must use one of the other options to unlock your wallet in order to send.
                        </h4>
                        <h5 translate="X_HelpfulLinks">
                            Helpful Links &amp; FAQs
                        </h5>
                        <ul>
                            <li class="u__protip">
                                <a href="https://myetherwallet.github.io/knowledge-base/getting-started/accessing-your-new-eth-wallet.html" target="_blank"
                                    rel="noopener noreferrer" translate="X_HelpfulLinks_1">
                                    How to Access your Wallet
                                </a>
                            </li>
                            <li class="u__protip">
                                <a href="https://myetherwallet.github.io/knowledge-base/private-keys-passwords/lost-eth-private-key.html" target="_blank"
                                    rel="noopener noreferrer" translate="X_HelpfulLinks_2">
                                    I lost my private key
                                </a>
                            </li>
                            <li class="u__protip">
                                <a href="https://myetherwallet.github.io/knowledge-base/private-keys-passwords/accessing-different-address-same-private-key-ether.html"
                                    target="_blank" rel="noopener noreferrer" translate="X_HelpfulLinks_3">
                                    My private key opens a different address
                                </a>
                            </li>
                            <li class="u__protip">
                                <a href="https://myetherwallet.github.io/knowledge-base/migration/" target="_blank" rel="noopener noreferrer" translate="X_HelpfulLinks_4">
                                    Migrating to/from MyEtherWallet
                                </a>
                            </li>
                        </ul>
                    </div>
                </article>
                <!-- If unlocked with PK -->
                <article class="block" ng-hide="wallet.type=='addressOnly'">
                    <!-- To Address -->
                    <div class="form-group">
                        <address-field placeholder="0xDECAF9CD2367cdbb726E904cD6397eDFcAe6068D" var-name="tx.to"></address-field>
                    </div>

                    <!-- Amount to Send -->
                    <section class="form-group">

                        <div class="clearfix">
                            <label translate="SEND_amount">
                                Amount to Send:
                            </label>
                        </div>

                        <div class="">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="{{ 'SEND_amount_short' | translate }}" ng-model="tx.value" ng-disabled="tx.readOnly || checkTxReadOnly"
                                    ng-class="Validator.isPositiveNumber(tx.value) ? 'is-valid' : 'is-invalid'" />

                                <div class="input-group-btn">

                                    <a style="min-width: 170px" class="btn btn-default dropdown-toggle" class="dropdown-toggle" ng-click="dropdownAmount = !dropdownAmount"
                                        ng-class="dropdownEnabled ? '' : 'disabled'">
                                        <strong>
                                            {{unitReadable}}
                                            <i class="caret"></i>
                                        </strong>
                                    </a>

                                    <!-- Amount to Send - Dropdown -->
                                    <ul class="dropdown-menu dropdown-menu-right" ng-show="dropdownAmount && !tx.readOnly">
                                        <li>
                                            <a ng-class="{true:'active'}[tx.sendMode=='ether']" ng-click="setSendMode('ether')">
                                                {{ajaxReq.type}}
                                            </a>
                                        </li>
                                        <li ng-repeat="token in wallet.tokenObjs track by $index" ng-show="token.balance!=0 &&
                                                                token.balance!='loading' &&
                                                                token.balance!='Click to Load' &&
                                                                token.balance.trim()!='Not a valid ERC-20 token' ||
                                                                token.type!=='default'">
                                            <a ng-class="{true:'active'}[unitReadable == token.getSymbol()]" ng-click="setSendMode('token', $index, token.getSymbol())">
                                                {{token.getSymbol()}}
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                        </div>

                        <!-- Amount to Send - Load Token Balances
                                            <a class="col-sm-1 send__load-tokens"
                                              title="Load Token Balances"
                                              ng-click="wallet.setTokens(); globalService.tokensLoaded=true"
                                              ng-hide="globalService.tokensLoaded">
                                                <img src="images/icon-load-tokens.svg" width="16" height="16" />
                                                <p translate="SEND_LoadTokens">
                                                  Load Tokens
                                                </p>
                                            </a>
                                            -->

                        <!-- Amount to Send - Transfer Entire Balance -->
                        <p class="" ng-hide="tx.readOnly">
                            <a ng-click="transferAllBalance()">
                                <span class="strong" translate="SEND_TransferTotal">
                                    Send Entire Balance
                                </span>
                            </a>
                        </p>

                    </section>

                    <!-- Gas Limit -->
                    <section class="form-group">
                        <div class="clearfix">
                            <!-- <a class="account-help-icon"
                                                href="https://myetherwallet.github.io/knowledge-base/gas/what-is-gas-ethereum.html"
                                                target="_blank"
                                                rel="noopener noreferrer">
                                                <img src="images/icon-help.svg" class="help-icon" />
                                                <p class="account-help-text" translate="GAS_LIMIT_Desc"></p>
                                              </a> -->
                            <label translate="TRANS_gas">
                                Gas Limit:
                            </label>
                            <input type="text" class="form-control" placeholder="52000" ng-model="tx.gasLimit" ng-change="gasLimitChanged=true" ng-disabled="tx.readOnly || checkTxReadOnly"
                                ng-class="Validator.isPositiveNumber(tx.gasLimit) ? 'is-valid' : 'is-invalid'" />
                        </div>
                    </section>

                    <!-- Advanced Option Panel -->
                    <a ng-click="showAdvance=true" ng-show='globalService.currentTab==globalService.tabs.sendTransaction.id || tx.data != ""'>
                        <p class="strong" translate="TRANS_advanced">
                            + Advanced: Add Data
                        </p>
                    </a>



                    <div ng-show="showAdvance || checkTxPage">
                        <!-- Data -->
                        <section class="form-group">
                            <div class="clearfix" ng-show="tx.sendMode=='ether'">
                                <!-- <span class="account-help-icon">
                                                  <img src="images/icon-help.svg" class="help-icon" />
                                                  <p class="account-help-text" translate="OFFLINE_Step2_Label_6b">
                                                    This is optional.
                                                  </p>
                                                </span> -->

                                <label translate="TRANS_data"> Data: </label>

                                <input type="text" class="form-control" placeholder="0x6d79657468657277616c6c65742e636f6d20697320746865206265737421" ng-model="tx.data"
                                    ng-disabled="tx.readOnly || checkTxReadOnly" ng-class="Validator.isValidHex(tx.data) ? 'is-valid' : 'is-invalid'"
                                />

                            </div>
                        </section>

                        <!-- Nonce -->
                        <section class="form-group" ng-show="checkTxPage">
                            <div class=" clearfix">

                                <a class="account-help-icon" href="https://myetherwallet.github.io/knowledge-base/transactions/what-is-nonce.html" target="_blank"
                                    rel="noopener noreferrer">
                                    <img src="images/icon-help.svg" class="help-icon" />
                                    <p class="account-help-text" translate="NONCE_Desc"></p>
                                </a>

                                <label translate="OFFLINE_Step2_Label_5">
                                    Nonce
                                </label>
                                <input type="text" class="form-control" placeholder="2" ng-model="tx.nonce" ng-disabled="checkTxReadOnly" ng-class="Validator.isPositiveNumber(tx.nonce) ? 'is-valid' : 'is-invalid'"
                                />

                            </div>
                        </section>

                        <!-- Gas Price -->
                        <section class="form-group" ng-show="checkTxPage">
                            <div class="clearfix">
                                <a class="account-help-icon" href="https://myetherwallet.github.io/knowledge-base/gas/what-is-gas-ethereum.html" target="_blank"
                                    rel="noopener noreferrer">
                                    <img src="images/icon-help.svg" class="help-icon" />
                                    <p class="account-help-text" translate="GAS_PRICE_Desc"></p>
                                </a>

                                <label translate="OFFLINE_Step2_Label_3">
                                    Gas Price:
                                </label>
                                <input type="text" class="form-control" placeholder="50" ng-model="tx.gasPrice" ng-disabled="checkTxReadOnly" ng-class="Validator.isPositiveNumber(tx.gasPrice) ? 'is-valid' : 'is-invalid'"
                                />

                            </div>
                        </section>

                    </div>
                    <!-- / Advanced Option Panel -->

                    <div class="clearfix form-group">
                        <div class="well" ng-show="wallet!=null && customGasMsg!=''">
                            <p>
                                <span translate="SEND_CustomAddrMsg">
                                    A message regarding
                                </span>
                                {{tx.to}}
                                <br />
                                <strong>
                                    {{customGasMsg}}
                                </strong>
                            </p>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class=" clearfix">
                            <a class="btn btn-info btn-block" ng-click="generateTx()" translate="SEND_generate">
                                Generate Transaction
                            </a>
                        </div>
                    </div>
                    <div class="form-group" ng-show="rootScopeShowRawTx">
                        <div class="col-sm-6">
                            <label translate="SEND_raw">
                                Raw Transaction
                            </label>
                            <textarea class="form-control" rows="4" readonly>{{rawTx}}</textarea>
                        </div>

                        <div class="col-sm-6">
                            <label translate="SEND_signed">
                                Signed Transaction
                            </label>
                            <textarea class="form-control" rows="4" readonly>{{signedTx}}</textarea>
                        </div>
                    </div>
                    <div class="clearfix form-group" ng-show="rootScopeShowRawTx">
                        <a class="btn btn-primary btn-block col-sm-11" data-toggle="modal" data-target="#sendTransaction" translate="SEND_trans"
                            ng-click="parseSignedTx( signedTx )">
                            Send Transaction
                        </a>
                    </div>
                </article>
            </div>

        </div>

    <!-- similar to sendTx-content.tpl --- END -->

        <!-- @@if (site === 'mew' ) { @@include( './sendTx-content.tpl', { "site": "mew" } ) }
        @@if (site === 'cx' ) { @@include( './sendTx-content.tpl',{ "site": "cx" } ) }  -->

        @@if (site === 'mew' ) { @@include( './sendTx-modal.tpl', { "site": "mew" } ) } 
        @@if (site === 'cx' ) { @@include( './sendTx-modal.tpl', { "site": "cx" } ) }
    </section>
</section>