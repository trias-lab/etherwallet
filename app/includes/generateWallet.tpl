<main class="tab-pane block--container active"
      ng-if="globalService.currentTab==globalService.tabs.generateWallet.id"
      ng-controller='walletGenCtrl'
      role="main"
      ng-cloak>
  <div class="tab-title">
    <div class="text">
      <h1 translate="NAV_GenerateWallet">Create New Wallet</h1>
      <div class="icon visible-xs-inline-block">
        <i class="fas fa-wallet"></i>
      </div>  
      <h2>By using Trias Wallet, you’ll be able to send and receive digital currency, swap between currencies and monitor your balance. </h2>
    </div>
    <div class="icon hidden-xs">
      <i class="fas fa-wallet"></i>
    </div>    
  </div>
  <article ng-class="!wallet && !showConfirmation? 'block__wrap gen__1 step-card active':'block__wrap gen__1 step-card'">
    <div class="step-title">
      <div class="num">1</div>
      <p class="text" aria-live="polite">
        Set Wallet Password
      </p>
      <i class="fas fa-check-circle success" ng-show="wallet && !showPaperWallet || showPaperWallet || showConfirmation"></i>
    </div>
    <section class="block__main gen__1--inner step-content" ng-show="!wallet && !showConfirmation">
      <p class="intro">
        This password encrypts your private key. This does not act as a seed to generate your keys. You will need this password + your private key to unlock your wallet.
      </p>
      <div class="input-label">
        Set wallet password
      </div>
      <input name="password"
           class="form-control"
           type="{{showPass && 'password' || 'text'}}"
           placeholder="{{'GEN_Placeholder_1' | translate }}"
           ng-model="password"
           ng-class="isStrongPass() ? 'is-valid' : 'is-invalid'"
           aria-label="{{'GEN_Label_1' | translate}}"
           />
<!--         <span tabindex="0"
            aria-label="make password visible"
            role="button"
            class="input-group-addon eye"
            ng-click="showPass=!showPass"> -->
      </span>
      <a tabindex="0"
         role="button"
         class="btn btn-primary"
         ng-click="genNewWallet()">
           Create New Wallet
      </a>
      <!-- @@include('./apple-mobile-modal.tpl', { "site": "" } )
      <p translate="x_PasswordDesc"></p>
      <div class="text-center">
        <strong>
          <a href="https://myetherwallet.github.io/knowledge-base/getting-started/creating-a-new-wallet-on-myetherwallet.html"
             target="_blank"
             rel="noopener noreferrer"
             translate="GEN_Help_5">
               How to Create a Wallet
          </a>
          &nbsp;&nbsp;&middot;&nbsp;&nbsp;
          <a href="https://myetherwallet.github.io/knowledge-base/getting-started/getting-started-new.html"
             target="_blank"
             rel="noopener noreferrer"
             translate="GEN_Help_6">
               Getting Started
          </a>
        </strong>
      </div>
      <br> -->
    </section>

<!--     <section class="block__help">

      <h2 translate="GEN_Help_0">
        Already have a wallet somewhere?
      </h2>

      <ul>
        <li>
          <p>
            <strong>
              Ledger / TREZOR / Digital Bitbox / Secalot
            </strong>:
            <span translate="GEN_Help_1">
              Use your
            </span>
            <a ng-click="globalService.currentTab=globalService.tabs.sendTransaction.id">
              hardware wallet
            </a>.
            <span translate="GEN_Help_3">
              Your device * is * your wallet.
            </span>
          </p>
        </li>
      </ul>

      <ul>
        <li>
          <p>
            <strong>
              MetaMask
            </strong>
            <span>
              Connect via your
            </span>
            <a ng-click="globalService.currentTab=globalService.tabs.sendTransaction.id">
              MetaMask Extension
            </a>.
            <span translate="GEN_Help_MetaMask">
              So easy! Keys stay in MetaMask, not on a phishing site! Try it today.
            </span>
          </p>
        </li>
      </ul>

      <ul>
        <li>
          <p>
            <strong>
              Jaxx / imToken
            </strong>
            <span translate="GEN_Help_1">Use your</span>
            <a ng-click="globalService.currentTab=globalService.tabs.sendTransaction.id" translate="x_Mnemonic">
              Mnemonic Phrase
            </a>
            <span translate="GEN_Help_2">
              to access your account.
            </span>
        </p>
        </li>
      </ul>

      <ul>
        <li>
          <p>
            <strong>
              Mist / Geth / Parity:
            </strong>
            <span translate="GEN_Help_1">
              Use your
            </span>
            <a ng-click="globalService.currentTab=globalService.tabs.sendTransaction.id" translate="x_Keystore2">
              Keystore File (UTC / JSON)
            </a>
            <span translate="GEN_Help_2">
              to access your account.
            </span>
          </p>
        </li>
      </ul>

    </section> -->

  </article>


  <article role="main" ng-class="wallet && !showPaperWallet ? 'block__wrap gen__2 step-card active':'block__wrap gen__2 step-card'" >
     <div class="step-title">
      <div class="num">2</div>
      <p class="text" aria-live="polite">
        Save Keystore file
      </p>
      <i class="fas fa-check-circle success" ng-show="showPaperWallet || showConfirmation"></i>
    </div>
    <section class="block__main gen__2--inner step-content" ng-show="wallet && !showPaperWallet">

      <div class="warn">
        <p class="GEN_Warning_1">
          <span class="emphasis">
            <i class="fas fa-exclamation-triangle"></i>
            Do not lose it!
          </span> 
          It cannot be recovered if you lose it.
        </p>
        <p class="GEN_Warning_2">
          <span class="emphasis">
            <i class="fas fa-exclamation-triangle"></i>
            Do not share it!
          </span> 
          Your funds will be stolen if you use this file on a malicious/phishing site.
        </p>
        <p class="GEN_Warning_3">
          <span class="emphasis">
            <i class="fas fa-exclamation-triangle"></i>
            Make a backup!
          </span> 
          Secure it like the millions of dollars it may one day be worth.
        </p>
      </div>

      <a tabindex="0" role="button"
         class="btn btn-default"
         href="{{blobEnc}}"
         download="{{encFileName}}"
         aria-label="{{'x_Download'|translate}} {{'x_Keystore'|translate}}"
         aria-describedby="x_KeystoreDesc"
         ng-click="downloaded()"
         rel="noopener noreferrer">
        <i class="fas fa-download"></i>
        <span translate="x_Download">
          DOWNLOAD
        </span>
        <span translate="x_Keystore2">
          Keystore File (UTC / JSON)
        </span>
      </a>

      <p>
        <a tabindex="0"
           role="button"
           class="btn btn-primary pull-right"
           ng-class="fileDownloaded ? '' : 'disabled' "
           ng-click="continueToPaper()">
            <span>
              I’ve Saved Keystore
            </span>
        </a>
      </p>

    </section>

<!--     <section class="block__help">
      <h2 translate="GEN_Help_8">
        Not Downloading a File?
      </h2>
      <ul>
        <li translate="GEN_Help_9">
          Try using Google Chrome
        </li>
        <li translate="GEN_Help_10">
          Right click &amp; save file as. Filename:
        </li>
        <input value="{{encFileName}}" class="form-control input-sm" />
      </ul>

      <h2 translate="GEN_Help_11">
        Don't open this file on your computer
      </h2>
      <ul>
        <li translate="GEN_Help_12">
          Use it to unlock your wallet via MyEtherWallet (or Mist, Geth, Parity &amp; other wallet clients.)
        </li>
      </ul>

      <h2 translate="GEN_Help_4">Guides &amp; FAQ</h2>
      <ul>
        <li>
          <a href="https://myetherwallet.github.io/knowledge-base/getting-started/backing-up-your-new-wallet.html" target="_blank" rel="noopener noreferrer">
            <strong translate="GEN_Help_13">
              How to Back Up Your Keystore File
            </strong>
          </a>
        </li>
        <li>
          <a href="https://myetherwallet.github.io/knowledge-base/private-keys-passwords/difference-beween-private-key-and-keystore-file.html" target="_blank" rel="noopener noreferrer">
            <strong translate="GEN_Help_14">
              What are these Different Formats?
            </strong>
          </a>
        </li>
      </ul>

    </section> -->

  </article>


  <article role="main" ng-class="showPaperWallet ? 'block__wrap gen__3 step-card active':'block__wrap gen__3 step-card'" >
    <div class="step-title">
      <div class="num">3</div>
      <p class="text" aria-live="polite">
        Save Private Key
      </p>
      <i class="fas fa-check-circle success" ng-show="showConfirmation"></i>
    </div>
    <section class="block__main gen__3--inner step-content" ng-show="showPaperWallet">
      <div class="warn">
        <p class="GEN_Warning_1">
          <span class="emphasis">
            <i class="fas fa-exclamation-triangle"></i>
            Do not lose it!
          </span> 
          It cannot be recovered if you lose it.
        </p>
        <p class="GEN_Warning_2">
          <span class="emphasis">
            <i class="fas fa-exclamation-triangle"></i>
            Do not share it!
          </span> 
          Your funds will be stolen if you use this file on a malicious/phishing site.
        </p>
        <p class="GEN_Warning_3">
          <span class="emphasis">
            <i class="fas fa-exclamation-triangle"></i>
            Make a backup!
          </span> 
          Secure it like the millions of dollars it may one day be worth.
        </p>
      </div>
      <textarea aria-label="{{'x_PrivKey'|translate}}"
             aria-describedby="{{'x_PrivKeyDesc'|translate}}"
             class="form-control"
             readonly="readonly"
             rows="2"
      >{{wallet.getPrivateKeyString()}}</textarea>

      <a tabindex="0"
         aria-label="{{'x_Print'|translate}}"
         aria-describedby="x_PrintDesc"
         role="button"
         class="btn btn-default"
         ng-click="printQRCode()">
         <i class="fas fa-print"></i>
          Print Paper Wallet
      </a>

      <a class="btn btn-primary pull-right" ng-click="confirm()">
        <span>I’ve Saved Private Key</span>
      </a>

    </section>

<!--     <section class="block__help">
      <h2 translate="GEN_Help_4">
        Guides &amp; FAQ
      </h2>
      <ul>
        <li><a href="https://myetherwallet.github.io/knowledge-base/getting-started/backing-up-your-new-wallet.html" target="_blank" rel="noopener noreferrer">
          <strong translate="HELP_2a_Title">
            How to Save & Backup Your Wallet.
          </strong>
        </a></li>
        <li><a href="https://myetherwallet.github.io/knowledge-base/getting-started/protecting-yourself-and-your-funds.html" target="_blank" rel="noopener noreferrer">
          <strong translate="GEN_Help_15">Preventing loss &amp; theft of your funds.</strong>
        </a></li>
        <li><a href="https://myetherwallet.github.io/knowledge-base/private-keys-passwords/difference-beween-private-key-and-keystore-file.html" target="_blank" rel="noopener noreferrer">
          <strong translate="GEN_Help_16">What are these Different Formats?</strong>
        </a></li>
      </ul>

      <h2 translate="GEN_Help_17">
        Why Should I?
      </h2>
      <ul>
        <li translate="GEN_Help_18">
          To have a secondary backup.
        </li>
        <li translate="GEN_Help_19">
          In case you ever forget your password.
        </li>
        <li>
          <a href="https://myetherwallet.github.io/knowledge-base/offline/ethereum-cold-storage-with-myetherwallet.html" target="_blank" rel="noopener noreferrer" translate="GEN_Help_20">Cold Storage</a>
        </li>
      </ul>

      <h2 translate="x_PrintDesc"></h2>

    </section> -->

  </article>

  <article role="main" ng-class="showConfirmation ? 'block__wrap gen__4 step-card active':'block__wrap gen__4 step-card'" >
    <div class="step-title">
      <div class="num">4</div>
      <p class="text" aria-live="polite">
        Confirmation
      </p>
    </div>
    <section class="block__main gen__4--inner step-content" ng-show="showConfirmation">

      <h1><i class="fas fa-check-circle"></i> You’re all set!</h1>
      <p class="intro">
        Make sure you’ve already properly saved your wallet password, Keystore file and Private Key. Remember there’s not way to recover any of them if you lost it, and you won’t be able to access your wallet.
      </p>
      <a class="btn btn-primary pull-right" ng-click="globalService.currentTab=globalService.tabs.viewWalletInfo.id">
        <span> Check My Account</span>
      </a>
      <a class="btn btn-default pull-right" ng-click="globalService.currentTab=globalService.tabs.homepage.id">
        <span> Back To Home</span> 
      </a>

    </section>
  </article>
<!-- 
  <article class="text-left" ng-show="showGetAddress">
    <div class="clearfix collapse-container">

      <div ng-click="wd = !wd">
        <a class="collapse-button"><span ng-show="wd">+</span><span ng-show="!wd">-</span></a>
        <h1 traslate="GEN_Unlock">Unlock your wallet to see your address</h1>
        <p translate="x_AddessDesc"></p>
      </div>

      <div ng-show="!wd">
          @@if (site === 'mew' ) {  <wallet-decrypt-drtv></wallet-decrypt-drtv>         }
          @@if (site === 'cx' )  {  <cx-wallet-decrypt-drtv></cx-wallet-decrypt-drtv>   }
      </div>
    </div>

    <div class="row" ng-show="wallet!=null" ng-controller='viewWalletCtrl'>
      @@if (site === 'cx' ) {  @@include( './viewWalletInfo-content.tpl', { "site": "cx" } )    }
      @@if (site === 'mew') {  @@include( './viewWalletInfo-content.tpl', { "site": "mew" } )   }
    </div>

  </article> -->
</main>
