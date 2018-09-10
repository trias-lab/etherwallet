<main class="tab-pane block--container active"
      ng-if="globalService.currentTab==globalService.tabs.homepage.id"
      role="main"
      ng-cloak>
  <div class="tab-title nav-card" ng-click="globalService.currentTab=globalService.tabs.generateWallet.id">
    <div class="text">
      <h1 translate="NAV_GenerateWallet">Create New Wallet</h1>
      <h2>By using Trias Wallet, you’ll be able to send and receive digital currency, swap between currencies and monitor your balance. </h2>
    </div>
    <div class="icon">
      <i class="fas fa-wallet"></i>
    </div>    
  </div>

  <div class="tab-title nav-card" ng-click="globalService.currentTab=globalService.tabs.sendTransaction.id">
    <div class="text">
      <h1 translate="NAV_SendTRI">Send TRI</h1>
      <h2>Send TRI to another Trias Wallet address. Be absolutely sure about what you’re doing, check the everything twice before initiating the transaction. </h2>
    </div>
    <div class="icon">
      <i class="fas fa-envelope"></i>
    </div>    
  </div>

  <div class="tab-title nav-card" ng-click="globalService.currentTab=globalService.tabs.swap.id">
    <div class="text">
      <h1 translate="NAV_Swap">Swap</h1>
      <h2>We offering you the ability to swap for other cryptocurrencies. You can also use this feature to send TRI directly to non-Trias addresses.</h2>
    </div>
    <div class="icon">
      <i class="fas fa-exchange-alt"></i>
    </div>    
  </div>

  <div class="tab-title nav-card" ng-click="globalService.currentTab=globalService.tabs.viewWalletInfo.id">
    <div class="text">
      <h1 translate="NAV_ViewAccount">View Account Info</h1>
      <h2>Check your account to view the private key and your address. If you forget to download the Paper Wallet or Keystore file, you can still do it here. </h2>
    </div>
    <div class="icon">
      <i class="fas fa-user-circle"></i>
    </div>    
  </div>

  <div class="tab-title nav-card" ng-click="globalService.currentTab=globalService.tabs.offlineTransaction.id">
    <div class="text">
      <h1 translate="OFFLINE_Title">Generate & Send Offline Transaction</h1>
      <h2>Send offline is the a very secure way to make a transaction. When transfering large amount of money, this method is recommended. </h2>
    </div>
    <div class="icon">
      <i class="fas fa-user-secret"></i>
    </div>    
  </div>
</main>
