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
      <h1 translate="NAV_SendEther">Send TRI</h1>
      <h2>Send TRI to another Trias Wallet address. 
        Be absolutely sure about what you’re doing, 
        check the everything twice before initiating the transaction.</h2>
    </div>
    <div class="icon">
      <i class="fas fa-envelope"></i>
    </div>    
  </div>

  <!-- Unlock Wallet -->
  <article class="collapse-container step-card" ng-class="!wd ? 'collapse-container step-card active':'collapse-container step-card'">
    <div ng-click="wd = !wd">
      <!-- <a class="collapse-button"><span ng-show="wd">+</span><span ng-show="!wd">-</span></a> -->
      <div class="step-title">
        <div class="num">1</div>
        <p class="text" aria-live="polite">
          Access your wallet
        </p>
        <i class="fas fa-check-circle success" ng-show="wallet && !showPaperWallet || showPaperWallet || showGetAddress"></i>
      </div>
      <!-- <h1 translate="NAV_SendEther">
        Send Ether &amp; Tokens
      </h1> -->
    </div>
    <div ng-show="!wd">
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
