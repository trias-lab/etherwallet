    <!-- Swap Kyber 4-->
    <article class="swap-order" ng-show="showStage4Kyber">

        <!-- Title -->
        <section class="row text-center">
            <div class="col-xs-3 text-left"><a class="btn btn-danger btn-xs" ng-click="newSwap()"> Start New Swap </a>
                <!-- todo: fix issues where new BigNumber() is not a number in sendTxCtrl: $scope.hasEnoughBalance function-->
            </div>
            <h5 class="col-xs-6" translate="SWAP_information">Your Information</h5>

        </section>

        <!-- Order Info -->
<!--         <section class="row order-info-wrap">
            <div class="col-sm-6 order-info">
                <h4> -->
                    <!--{{kyberOrderResult.output.amount | number: receiveDecimals}}--> <!-- {{kyberSwapOrder.fromVal * kyberSwapOrder.swapRate | number: receiveDecimals}} {{kyberOrderResult.output.currency}}</h4>
                <p translate="SWAP_rec_amt">Amount to receive</p>
            </div>
            <div class="col-sm-6 order-info">
                <h4>{{kyberSwapOrder.swapRate | number: 6}} {{kyberSwapOrder.swapPair}}</h4>
                <p translate="SWAP_your_rate">Your rate</p>
            </div>
        </section> -->


        <!-- Swap Progress -->
        <section class="row swap-progress">
            <div class="sep"></div>
            <div class="progress-item {{kyberOrderResult.progress.bar[0]}}">
                <div class="progress-circle"><i>1</i></div>
                <p translate="SWAP_progress_1">Order Initiated</p>
            </div>
            <div class="progress-item {{kyberOrderResult.progress.bar[1]}}" ng-if="!kyberEthToToken">
                <div class="progress-circle"><i>2</i></div>
                <p><span translate="SWAP_progress_2">Waiting for your </span> {{kyberOrderResult.input.currency}}...</p>
            </div>
            <div class="progress-item {{kyberOrderResult.progress.bar[2]}}" ng-if="!kyberEthToToken">
                <div class="progress-circle"><i>3</i></div>
                <p>{{kyberOrderResult.input.currency}} <span translate="SWAP_progress_3">Received!</span></p>
            </div>
            <div class="progress-item {{kyberOrderResult.progress.bar[3]}}">
                <div class="progress-circle"><i>4</i></div>
                <p>
                    <!--<span translate="SWAP_progress_4">Sending your </span> {{kyberOrderResult.output.currency}} <br/>-->
                    <span >Broadcasting your </span> {{kyberOrderResult.output.currency}} <span> order</span><br/>
                </p>
            </div>
            <div class="progress-item {{kyberOrderResult.progress.bar[4]}}">
                <div class="progress-circle"><i>5</i></div>
                <!--<p translate="SWAP_progress_5">Order Complete</p>-->
                <p>Order Broadcast to Blockchain</p>
            </div>
        </section>

        <article class="row">
            <div class="col-sm-2 text-center">
                <em>
                    <small>Powered By</small>
                </em>
                <a class="link" href="https://home.kyber.network/" target="_blank"
                   rel="noopener noreferrer">
                    <img class="pull-right" src="images/Kyber-Network-Main-Logo.svg" width="400" height="222"/>
                </a>
            </div>
            <div class="col-sm-10 text-justify">
                <div class="row">
                    <section class="col-sm-6">
                        <div class="col-sm-12">
                            <h3>Transaction Summary:</h3>
                        </div>
                        <div class="col-sm-12">
                            <h4>{{kyberOrderResult.input.amount}} {{kyberOrderResult.input.currency}}</h4>
                            <p>Amount sent</p>
                        </div>
                        <div class="col-sm-12">
                            <h4><!--{{kyberOrderResult.output.amount | number: receiveDecimals}}--> {{kyberSwapOrder.fromVal * kyberSwapOrder.swapRate | number: receiveDecimals}} {{kyberOrderResult.output.currency}}</h4>
                            <p translate="SWAP_rec_amt">Amount to receive</p>
                        </div>
                        <div class="col-sm-12">
                            <h4>{{kyberSwapOrder.swapRate | number: 6}} {{kyberSwapOrder.swapPair}}</h4>
                            <p translate="SWAP_your_rate">Your rate</p>
                        </div>
                        <hr>
                        <div class="col-sm-12">
                            <h5>Transaction Hash(es):</h5>
                        </div>

                        <!-- Token to ETH -->
                        <div class="col-sm-12" ng-if="!kyberEthToToken && !kyberTransaction.bypassTokenApprove">
                            <span>
                                Track your swap transaction:
                            </span>
                            <div ng-if="!kyberTransaction.tokenTxHash">
                                <br>
                                <span  class="text-info"><em><small>Your Swap Waiting for token authorization</small></em> <span ng-repeat="tick in indicatorhacked track by $index">{{tick}}</span></span><br>
                                <span class="text-danger"><br> Do Not Navigate Away or Close Your Browser</span>

                            </div>
                            <a class="strong" ng-href="{{kyberTransaction.tokenTxLink}}" target="_blank" rel="noopener">
                                <h5>{{kyberTransaction.tokenTxHash}}</h5>
                            </a>
                        </div>

                        <div class="col-sm-12" ng-if="!kyberEthToToken && !kyberTransaction.bypassTokenApprove">
                            <span>
                                Track your token authorization transaction:
                         </span>
                            <!--{{kyberTransaction.tokenNeedsReset}}-->
                            <div ng-if="!kyberTransaction.tokenResetTxHash && kyberTransaction.tokenResetTx">
                                <br>
                                <span  class="text-info"><em><small>Preparing Token State for Token Authorization</small></em> <span ng-repeat="tick in indicatorTokenReset track by $index">{{tick}}</span></span><br>
                            </div>
                            <br ng-if="!kyberTransaction.tokenApproveTxLink">
                            <a class="strong" ng-href="{{kyberTransaction.tokenApproveTxLink}}" target="_blank"
                               rel="noopener">

                                <h5>{{kyberTransaction.tokenApproveTxHash}}</h5>
                            </a>
                        </div>
                        <!-- / Token to ETH -->

                        <!-- Token to ETH ( with reset token allowance) -->
                        <div class="col-sm-12" ng-if="kyberTransaction.tokenResetTx">
                            <span>
                                Track your token approval reset transaction:
                            </span>
                            <a class="strong" ng-href="{{kyberTransaction.tokenResetTxLink}}" target="_blank" rel="noopener">
                                <h5>{{kyberTransaction.tokenResetTxHash}}</h5>
                            </a>
                        </div>
                        <!-- / Token to ETH ( with reset token allowance) -->

                        <!-- ETH to Token-->
                        <div class="col-sm-12" ng-if="kyberEthToToken">
                          <span>
                              Track your swap transaction:
                          </span>
                            <a class="strong" ng-href="{{kyberTransaction.ethTxLink}}" target="_blank" rel="noopener">

                                <h5>{{kyberTransaction.ethTxHash}}</h5>
                            </a>
                        </div>
                        <!-- / ETH to Token-->

                        <!-- Token to ETH (no approval needed)-->
                        <div class="col-sm-12" ng-if="!kyberEthToToken && kyberTransaction.bypassTokenApprove">
                                                        <span>
                                Track your swap transaction:
                            </span>
                            <div ng-if="!kyberTransaction.tokenTxHash">
                                <br>
                                <!--<span  class="text-info"><em><small>Your Swap Waiting for token authorization</small></em> <span ng-repeat="tick in indicatorhacked track by $index">{{tick}}</span></span><br>-->
                                <span class="text-danger"><br> Do Not Navigate Away or Close Your Browser</span>

                            </div>
                            <a class="strong" ng-href="{{kyberTransaction.tokenTxLink}}" target="_blank" rel="noopener">
                                <h5>{{kyberTransaction.tokenTxHash}}</h5>
                            </a>
                        </div>
                        <!-- / Token to ETH (no approval needed)-->

                    </section>
                </div>
                <!--<div ng-repeat="(key, entry) in kyberTransaction track by key">
                    {{key}}:  {{entry}}
                </div>-->


            </div>
        </article>
<!--        <div class="row text-center">
            <span> Common Questions: </span><br/>
            <a href="https://myetherwallet.github.io/knowledge-base/faq/eth-or-tokens-not-showing-on-exchange.html" target="_blank"
               rel="noopener noreferrer"> ETH or Tokens haven't shown up </a><br/>
            <a href="https://myetherwallet.github.io/knowledge-base/transactions/transactions-not-showing-or-pending.html" target="_blank"
               rel="noopener noreferrer"> Transactions are Not Showing Up or Pending Forever </a><br/>
            <span> Still need help: </span>
        </div>-->

    </article>

    <!-- / Swap Kyber 4-->