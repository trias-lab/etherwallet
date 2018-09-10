<main class="tab-pane active"
      ng-if="globalService.currentTab==globalService.tabs.sendTransaction.id"
      ng-controller='sendTxCtrl'
      ng-cloak >

  <!-- Header : todo turn into warning notification-->
  <div class="alert alert-info" ng-show="hasQueryString">
    <p translate="WARN_Send_Link">
      You arrived via a link that has the address, amount, gas or data fields filled in for you. You can change any information before sending. Unlock your wallet to get started.
    </p>
  </div>

  <div class="tab-title">
    <div class="text">
      <h1 translate="NAV_SendTRI">Send TRI</h1>
      <div class="icon visible-xs-inline-block">
        <i class="fas fa-envelope"></i>
      </div>  
      <h2>Send TRI to another Trias Wallet address. 
        Be absolutely sure about what you’re doing, 
        check the everything twice before initiating the transaction.</h2>
    </div>
    <div class="icon hidden-xs">
      <i class="fas fa-envelope"></i>
    </div>    
  </div>

  <!-- Unlock Wallet -->
  <article class="collapse-container step-card" ng-class="!wd ? 'collapse-container step-card active':'collapse-container step-card'">
    <div ng-click="wd = !wd">
      <div class="step-title">
        <div class="num">1</div>
        <p class="text" aria-live="polite">
          Access your wallet
        </p>
         <a class="collapse-button pull-right">
          <i class="fas fa-plus-square" ng-show="wd"></i><i class="fas fa-minus-square" ng-show="!wd"></i>
        </a>
      </div>
    </div>
    <div ng-show="!wd" class="step-content wallet-decrypt-container">
        @@if (site === 'cx' )  {  <cx-wallet-decrypt-drtv></cx-wallet-decrypt-drtv>   }
        @@if (site === 'mew' ) {  <wallet-decrypt-drtv></wallet-decrypt-drtv>         }
    </div>
  </article>


  <!-- Send Tx Content -->
  <!-- <article class="row" ng-show="wallet!=null"> -->
    @@if (site === 'mew' ) { @@include( './sendTx-content.tpl', { "site": "mew" } ) }
    @@if (site === 'cx'  ) { @@include( './sendTx-content.tpl', { "site": "cx"  } ) }

    @@if (site === 'mew' ) { @@include( './sendTx-modal.tpl',   { "site": "mew" } ) }
    @@if (site === 'cx'  ) { @@include( './sendTx-modal.tpl',   { "site": "cx"  } ) }
  <!-- </article> -->


</main>
