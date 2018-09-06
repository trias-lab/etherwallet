<!-- Swap Rates Panel -->

<!-- <article class="swap-rates" ng-show="showStage1">

  <section class="row">
    <h5 class="col-xs-6 col-xs-offset-3" translate="SWAP_rates"> Current Rates </h5>
  </section>
  <section class="row order-panel">
    <div class="col-sm-4 order-info">
      <p class="mono">
        <input class="form-control input-sm" ng-model="priceTicker.ETHBTC"/>
        <span>ETH = {{bity.curRate.ETHBTC*priceTicker.ETHBTC | number: 6}} BTC</span>
      </p>
      <p class="mono">
        <input class="form-control input-sm" ng-model="priceTicker.ETHREP"/>
        <span>ETH = {{bity.curRate.ETHREP*priceTicker.ETHREP | number: 6}} REP</span>
      </p>
    </div>
    <div class="col-sm-4 order-info">
        <div class="row">
            <div class="col-sm-6">
                <a class="link bity-logo pull-left" href="https://bity.com/af/jshkb37v" target="_blank" rel="noopener noreferrer"><img src="images/logo-bity-white.svg" width="120" height="49" /></a>
            </div>
            <div class="col-sm-6">
                <a class="link bity-logo pull-right" href="https://home.kyber.network/" target="_blank" rel="noopener noreferrer"><img src="images/Kyber-Network-Main-Logo-Inverted.svg" width="200" height="111" /></a>

            </div>
        </div>
    </div>
    <div class="col-sm-4 order-info">
      <p class="mono">
        <input class="form-control input-sm" ng-model="priceTicker.BTCETH"/>
        <span>BTC = {{bity.curRate.BTCETH*priceTicker.BTCETH | number: 6}} ETH</span>
      </p>
      <p class="mono">
        <input class="form-control input-sm" ng-model="priceTicker.BTCREP"/>
        <span>BTC = {{bity.curRate.BTCREP*priceTicker.BTCREP | number: 6}} REP</span>
      </p>
    </div>

  </section>


</article> -->



<!-- / Swap Rates Panel -->



<!-- Swap Init Panel -->
<article class="swap-panel clearfix">

  <div  ng-class="showStage1 ?'swap-panel-tit':'swap-panel-tit not-slect'">

    <div class="swap-pane-step">1</div> 
    <span>Swap Detail</span> 
    <i class="fas fa-check-circle success"   ng-show="!showStage1"></i>
  </div>

  <div class="swap-panel-warp" ng-show="showStage1">

    <div class="clearfix swap-panel-step1">

      <div style="float: left;width: 43%">
        <label for="original">
          Original  
          <br>
          <input id="original" class="form-control" type="text" placeholder="{{ 'SEND_amount_short' | translate }}" ng-change="updateEstimate(true)"
            ng-model="swapOrder.fromVal" ng-click="resetErrorShownStates()" ng-class="Validator.isPositiveNumber(swapOrder.fromVal)  && verifyMinMaxValues() ? 'is-valid' : 'is-invalid'"
          />
          <div class="dropdown" ng-click="dropdownFrom = !dropdownFrom">
              {{swapOrder.fromCoin}}<i class="caret"></i>
              <ul class="dropdown-menu dropdown-menu-right" ng-show="dropdownFrom">
                <li ng-repeat="coin in availableFromOptions track by $index" ng-show="showInFromList(coin)">
                  <a ng-class="{true:'active'}[coin == swapOrder.fromCoin]" ng-click="setOrderCoin(true, coin)"> {{coin}} </a>
                </li>
              </ul>
            </div>
        </label>
      

      </div>




      <div  class="original-to-target"> 
          <i class="fa fa-arrow-right" aria-hidden="true"></i>
      </div>

      <div style="float:right;width: 42%">
        <label for="target">
          Target
          <br>
          <input id="target" class="form-control" type="text" placeholder="{{ 'SEND_amount_short' | translate }}" ng-change="updateEstimate(false)"
            ng-model="swapOrder.toVal" ng-click="resetErrorShownStates()" ng-class="Validator.isPositiveNumber(swapOrder.toVal) && verifyMinMaxValues() ? 'is-valid' : 'is-invalid'"
          />

          <div class="dropdown"  ng-click="dropdownTo = !dropdownTo">
              {{swapOrder.toCoin}}<i class="caret"></i>
              <ul class="dropdown-menu dropdown-menu-right" ng-show="dropdownTo">
                <li ng-repeat="coin in availableToOptions track by $index" ng-show="showInToList(coin)">
                  <a ng-class="{true:'active'}[coin == swapOrder.toCoin]" ng-click="setOrderCoin(false, coin)"> {{coin}} </a>
                </li>
              </ul>
            </div>
        </label>
      
      </div>
    </div>

    
    <div class="generateTransaction-button clearfix">
        <a ng-click="setFinalPrices()" class="btn btn-info btn-default">
          <span translate="SWAP_init_CTA"> Generate Transaction </span>
        </a>
        <!-- <section class="row">
          <div class="col-xs-6 col-xs-offset-3" >
            <h4 style="margin-top: 40px; border: 5px #0b1929">
              <a href="https://ccswap.myetherwallet.com" > Buy ETH with <img src="images/visa-master.png" width="60" height="30"></a>
            </h4>
          </div>
        </section> -->
      </div>
  </div>



  <!-- <div class="col-xs-12 clearfix text-center" ng-if="isKyberRateSwap">
    <span> 1 {{swapOrder.fromCoin}} = {{kyber.kyberRates[swapOrder.fromCoin + "/" + swapOrder.toCoin] | number: 6}} {{swapOrder.toCoin}}</span>
  </div> -->




</article>
<!-- / Swap Init Panel -->