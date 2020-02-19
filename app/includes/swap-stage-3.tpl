<article>
    <article class="swap-order">

        <!-- Title -->
        <!-- <section class="row text-center">
            <div class="col-xs-3 text-left"><a class="btn btn-danger btn-xs" ng-click="newSwap()"> Start New Swap </a>
            </div>
            <h5 class="col-xs-6" translate="SWAP_information">Your Information</h5>
            <div class="col-xs-3"><a class="link" href="https://bity.com/af/jshkb37v" target="_blank"
                                     rel="noopener noreferrer">
                <img class="pull-right" src="images/logo-bity.svg" width="100" height="38"/>
            </a></div>
        </section> -->

        <!-- Order Info -->
        <!-- <section class="row order-info-wrap">
            <div class="col-sm-3 order-info">
                <h4>{{orderResult.reference}}</h4>
                <p translate="SWAP_ref_num">Your reference number</p>
            </div>
            <div class="col-sm-3 order-info">
                <h4>{{orderResult.progress.timeRemaining}}</h4>
                <p ng-show="orderResult.progress.showTimeRem" translate="SWAP_time">Time remaining to send</p>
                <p translate="SWAP_elapsed" ng-show="!orderResult.progress.showTimeRem">Time elapsed since sent</p>
            </div>
            <div class="col-sm-3 order-info">
                <h4>{{orderResult.output.amount}} {{orderResult.output.currency}}</h4>
                <p translate="SWAP_rec_amt">Amount to receive</p>
            </div>
            <div class="col-sm-3 order-info">
                <h4>{{swapOrder.swapRate}} {{swapOrder.swapPair}}</h4>
                <p translate="SWAP_your_rate">Your rate</p>
            </div>
        </section> -->


        <!-- Swap Progress -->
        <!-- <section class="row swap-progress">
            <div class="sep"></div>
            <div class="progress-item {{orderResult.progress.bar[0]}}">
                <div class="progress-circle"><i>1</i></div>
                <p translate="SWAP_progress_1">Order Initiated</p>
            </div>
            <div class="progress-item {{orderResult.progress.bar[1]}}">
                <div class="progress-circle"><i>2</i></div>
                <p><span translate="SWAP_progress_2">Waiting for your </span> {{orderResult.input.currency}}...</p>
            </div>
            <div class="progress-item {{orderResult.progress.bar[2]}}">
                <div class="progress-circle"><i>3</i></div>
                <p>{{orderResult.input.currency}} <span translate="SWAP_progress_3">Received!</span></p>
            </div>
            <div class="progress-item {{orderResult.progress.bar[3]}}">
                <div class="progress-circle"><i>4</i></div>
                <p>
                    <span translate="SWAP_progress_4">Sending your </span> {{orderResult.output.currency}} <br/>
                    <small ng-show="orderResult.input.currency=='ETH'"> Waiting for 10 confirmations...</small>
                    <small ng-show="orderResult.input.currency=='BTC'"> Waiting for 1 confirmation...</small>
                </p>
            </div>
            <div class="progress-item {{orderResult.progress.bar[4]}}">
                <div class="progress-circle"><i>5</i></div>
                <p translate="SWAP_progress_5">Order Complete</p>
            </div>
        </section> -->


        <!-- Swap CTA -->
        <section style="overflow: hidden;" ng-show="orderResult.progress.status=='OPEN' || showStage3Kyber">
            <h5>
                <span translate="SWAP_order_CTA"> Please send </span>
                <strong style="padding: 5px;background:#FEFEFE;display: inline-block; color: #5DB85C;">
                    {{!isKyberSwap? orderResult.input.amount : kyberOrderResult.input.amount}}
                    {{!isKyberSwap? orderResult.input.currency : kyberOrderResult.input.currency}} </strong>
                <span ng-show="!isKyberSwap" translate="SENDModal_Content_2"> to address </span>
                <strong ng-show="!isKyberSwap" style="padding: 5px;background:#FEFEFE;display: inline-block;color: #5DB85C;" class="mono text-primary">
                    {{orderResult.payment_address}}
                </strong>
            </h5>
            <p style="color:#142A3F">Your money will be transfered to a temperary address to complete the swap.</p>
        </section>

        <!-- Swap CTA ETH -->
        <section class="swap-panel">

            <div ng-class="(orderResult.progress.status=='OPEN' || showStage3Kyber) && wallet== null && walletKyber==null?'swap-panel-tit':'swap-panel-tit not-slect'" ng-click="wd = !wd">
                <div class="swap-pane-step">3</div>
                <span>How would you like to access your wallet?</span>
                <!-- <i class="fas fa-check-circle success" ng-show="orderResult.progress.status=='FILL'||orderResult.progress.status=='RCVE' || showStage4Kyber"></i> -->
                <i class="fas fa-plus-square" ng-show="wd && (orderResult.progress.status=='OPEN' || showStage3Kyber)"></i><i class="fas fa-minus-square" ng-show="!wd && (orderResult.progress.status=='OPEN' || showStage3Kyber)"></i>
            </div>
            <div ng-show="!wd && (orderResult.progress.status=='OPEN' || showStage3Kyber)">
                @@if (site === 'mew' ) {
                <wallet-decrypt-drtv></wallet-decrypt-drtv>
                } @@if (site === 'cx' ) {
                <cx-wallet-decrypt-drtv></cx-wallet-decrypt-drtv>
                }
            </div>


        </section>

        <section ng-show="showStage3Kyber && wallet!=null " ng-controller="sendTxCtrl">
            <h5 class="text-center">
                Wallet Unlocked!
            </h5>  <!-- todo: add translate -->

            <section class="text-center" ng-if="kyberReturnToStart">
                <h5 class="text-warning">The swap value of {{kyberSwapOrder.fromVal}} {{kyberSwapOrder.fromCoin}} is Greater
                                         than your current {{kyberSwapOrder.fromCoin}} Balance of
                                         {{userTokenBalanceChecked}} {{kyberSwapOrder.fromCoin}}</h5>
                <a ng-click="returnToStart()" class="btn btn-primary btn-lg"><span> Return to Swap Selector </span></a>
                <!-- todo: add translate -->
            </section>
            <section class="text-center" ng-show="wallet!=null && !balanceOk">
                <br/>
                <h6 ng-show="!kyberReturnToStart"> Processing</h6>
            <span ng-show="!kyberReturnToStart"> <span ng-repeat="tick in indicatorhacked track by $index">{{tick}}</span></span>
            </section>
            <section class="text-center" ng-show="wallet!=null && balanceOk">
                <a ng-click="openKyberOrder(wallet)" class="btn btn-primary btn-lg"><span
                        translate="SWAP_start_CTA"> Start Swap </span></a>

<!--{{kyberSwapOrder.toAddress}}-->
                <!--{{wallet.getAddressString()}}-->
                <div ng-if="kyberSwapOrder.toAddress.toLowerCase() != wallet.getAddressString().toLowerCase() ">
                    <h4 style="color: red">WAIT! The Address you are sending to is not the wallet address you unlocked. <br> If this is not what you intended please review your receiving address.</h4>
                    <a ng-click="returnToSetDestinationAddress()" class="btn btn-primary btn-lg"><span> Return to Set Receiving Address </span></a>
                </div>
            </section>

         <!-- Included Because sendTxCtrl.js looks for it via querySelector and throws if it is not present (and destroys the layout in the process)-->

               @@if (site === 'mew' ) { @@include(
               './swap-kyber-modal.tpl', { "site": "mew" } ) }
               <!--todo implement (custom swap modal) with content comming from swapCtrl -->
               @@if (site === 'cx' ) { @@include(
               './swap-kyber-modal.tpl', { "site": "cx" } ) }
        </section>
    </article>
    <!-- / Swap CTA ETH -->

</article>