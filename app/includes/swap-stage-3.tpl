<article ng-if="!isKyberSwap">
    <article class="swap-order" ng-show="showStage3Btc || showStage3Eth">

        <section class="row text-center">
            <div class="col-xs-3 text-left"><a class="btn btn-danger btn-xs" ng-click="newSwap()"> Start New Swap </a>
            </div>
        </section>
        
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
        <section style="margin-bottom: 36px;overflow: hidden;" ng-show="orderResult.progress.status=='OPEN'">
            <h5>
                <span translate="SWAP_order_CTA"> Please send </span>
                <strong style="padding: 5px;background:#FEFEFE;display: inline-block; color: #5DB85C;"> {{orderResult.input.amount}}
                    {{orderResult.input.currency}} </strong>
                <span translate="SENDModal_Content_2"> to address </span>
                <strong style="padding: 5px;background:#FEFEFE;display: inline-block;color: #5DB85C;" class="mono text-primary"> {{orderResult.payment_address}}
                </strong>
            </h5>
            <p style="color:#142A3F">Your money will be transfered to a temperary address to complete the swap.</p>
        </section>


        <!-- Swap CTA ETH -->
        <section class="swap-panel" ng-show="showStage3Eth && orderResult.progress.status=='OPEN'">

            <div ng-class="!isKyberSwap && !wd ?'swap-panel-tit':'swap-panel-tit not-slect'">
                <div class="swap-pane-step">3</div>
                <span>How would you like to access your wallet?</span>
                <i class="fas fa-check-circle success" ng-show="!isKyberSwap"></i>
            </div>
            <div ng-show="!wd">
                @@if (site === 'mew' ) {
                <wallet-decrypt-drtv></wallet-decrypt-drtv>
                } @@if (site === 'cx' ) {
                <cx-wallet-decrypt-drtv></cx-wallet-decrypt-drtv>
                }
            </div>



        </section>
    </article>
    <!-- / Swap CTA ETH -->


    <!-- Swap CTA BTC -->
    <section class="row block swap-address text-center" ng-show="showStage3Btc && orderResult.progress.status=='OPEN'">
        <label translate="x_Address"> Your Address </label>
        <div class="qr-code" qr-code="{{'bitcoin:'+orderResult.payment_address+'?amount='+orderResult.input.amount}}" watch-var="orderResult"></div>
        <br/>
        <p class="text-danger">
            Orders that take too long will have to be processed manually &amp; and may delay the amount of time it takes to receive your
            coins.
            <br/>
            <a href="https://shapeshift.io/#/btcfee" target="_blank" rel="noopener noreferrer">Please use the recommended
                TX fees seen here.</a>
        </p>

    </section>


</article>

</article>