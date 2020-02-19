<main class="tab-pane block--container active" ng-if="globalService.currentTab==globalService.tabs.viewWalletInfo.id" ng-controller='viewWalletCtrl' ng-cloak>

<div class="tab-title">
    <div class="text">
      <h1 translate="NAV_ViewAccount">View Account Info</h1>
      <div class="icon visible-xs-inline-block">
        <i class="fas fa-user-circle"></i>
      </div> 
      <h2>Check your account to view the private key and your address. If you forget to download the Paper Wallet or Keystore file, you can still do it here.</h2>
    </div>
    <div class="icon hidden-xs">
      <i class="fas fa-user-circle"></i>
    </div>  
  </div>

  <article role="main" ng-class="!wallet || !wd ?'collapse-container block__wrap view__1 step-card active':'collapse-container block__wrap view__1 step-card'" >
    <div class="step-title" ng-click="wd = !wd">
      <div class="num">1</div>
      <p class="text" aria-live="polite">
        Access your wallet
      </p>
      <a class="collapse-button pull-right">
        <i class="fas fa-plus-square" ng-show="wd"></i><i class="fas fa-minus-square" ng-show="!wd"></i>
      </a>
    </div>
    <section class="block__main view__1--inner step-content wallet-decrypt-container" ng-show="!wd">
      <wallet-decrypt-drtv></wallet-decrypt-drtv>
    </section>
  </article>

  <article>
    @@if (site === 'cx' ) {  @@include( './viewWalletInfo-content.tpl', { "site": "cx" } )    }
    @@if (site === 'mew') {  @@include( './viewWalletInfo-content.tpl', { "site": "mew" } )   }
  </article> 
</main>
