<!-- send offline -->
<main class="tab-pane active sendOffline-box" ng-if="globalService.currentTab==globalService.tabs.offlineTransaction.id"
  ng-controller='offlineTxCtrl' ng-cloak>

  <div class="sendOffline-title-box clearfix">
    <h1 translate="OFFLINE_Title" class="sendOffline-title">
      Generate &amp; Send Offline Transaction
    </h1>
    <i class="fa fa-user-secret send-title-icon"></i>
    <h2 class="sendOffline-intro">By using Trias Wallet, you’ll be able to send and receive digital currency, swap between
      currencies and monitor your balance.</h2>
  </div>
  <div ng-hide='sendDealStep.sendDealStep==1'>
      <h2 class="col-xs-11 clearfix sendOffline-step-title-finish">
          1、How would you like to access your wallet?
      </h2>
  </div>
  
  <div ng-show='sendDealStep.sendDealStep==1'>
      
    @@if (site === 'mew' ) { @@include( './offlineTx-1.tpl', { "site": "mew" } ) } @@if (site === 'cx' ) { @@include( './offlineTx-1.tpl',
    { "site": "cx" } ) }
  </div>
  <div ng-hide='sendDealStep.sendDealStep==2'>
      <h2 class="col-xs-11 clearfix sendOffline-step-title-finish" translate="OFFLLINE_Step1_Title">Step 1: Generate Information (Online
          Computer)</h2>
  </div>
  <div ng-show='sendDealStep.sendDealStep==2'>
    @@if (site === 'mew' ) { @@include( './offlineTx-2.tpl', { "site": "mew" } ) } @@if (site === 'cx' ) { @@include( './offlineTx-2.tpl',
    { "site": "cx" } ) }

  </div>
  <div ng-hide='sendDealStep.sendDealStep==3'>
      <h2 class="col-xs-11 clearfix sendOffline-step-title-finish" translate="OFFLINE_Step2_Title">
          Step 2: Generate Transaction (Offline Computer)
        </h2>
  </div>
  <div ng-show='sendDealStep.sendDealStep==3'>
    @@if (site === 'mew' ) { @@include( './offlineTx-3.tpl', { "site": "mew" } ) } @@if (site === 'cx' ) { @@include( './offlineTx-3.tpl',
    { "site": "cx" } ) }
  </div>
  <div ng-hide='sendDealStep.sendDealStep==4'>
      <h2 class="col-xs-11 clearfix sendOffline-step-title-finish" translate="OFFLINE_Step3_Title">
          Step 3: Send / Publish Transaction
      </h2>
  </div>
  <div ng-show='sendDealStep.sendDealStep==4'>
    @@if (site === 'mew' ) { @@include( './offlineTx-4.tpl', { "site": "mew" } ) } @@if (site === 'cx' ) { @@include( './offlineTx-4.tpl',
    { "site": "cx" } ) }
  </div>






  @@if (site === 'mew' ) { @@include( './offlineTx-modal.tpl', { "site": "mew" } ) } @@if (site === 'cx' ) { @@include( './offlineTx-modal.tpl',
  { "site": "cx" } ) }

</main>