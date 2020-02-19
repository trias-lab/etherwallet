
<article ng-show="wallet!=null">
  <wallet-balance-drtv></wallet-balance-drtv>
</article>

<article role="main" ng-class="wallet!=null && wd?'block__wrap view__2 step-card active':'block__wrap view__2 step-card'" >
  <div class="step-title">
    <div class="num">2</div>
    <p class="text" aria-live="polite">
      Account Info
    </p>
  </div>

  <section class="block__main view__2--inner step-content" ng-show="wallet!=null">
    <article class="view-wallet-content">
      <hr>
      <div class="row">
        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
          <div class="account-help-icon">           
            <h5 translate="x_Address">
              Your Address:
            </h5>
            <img src="images/icon-help.svg" class="help-icon" />
            <p class="account-help-text" translate="x_AddessDesc">
              You may know this as your "Account #" or your "Public Key". It's what you send people so they can send you ETH. That icon is an easy way to recognize your address.
              This Keystore / JSON file matches the format used by Mist & Geth so you can easily import it in the future. It is the recommended file to download and back up.
            </p>
          </div>
        </div>

        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12">
          <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 address-identicon-container">
            <div class="addressIdenticon"
                 title="Address Indenticon"
                 blockie-address="{{wallet.getAddressString()}}"
                 watch-var="wallet">
            </div>
          </div>
          <span class="col-lg-10 col-md-10 col-sm-10 col-xs-10 address">{{wallet.getChecksumAddressString()}}</span>
          </div>         
          <div class="row"> 
            <a class="btn btn-primary" href="{{blobEnc}}" download="{{encFileName}}" ng-show='showEnc'>
              <span translate="x_Download">
                DOWNLOAD
              </span>
              <span translate="x_Keystore2">
                Keystore File (UTC / JSON)
              </span>
            </a>
          </div>
        </div>

        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-12 text-right">
          <div class="qr-code" qr-code="{{wallet.getChecksumAddressString()}}" watch-var="wallet" width="100%"></div>
        </div>
      </div>

      <hr>

      <div class="row">
        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
          <div class="account-help-icon">
            <h5>
              <span translate="x_PrivKey">
                Private Key (unencrypted)
              </span>
            </h5>
            <img src="images/icon-help.svg" class="help-icon" />
            <p class="account-help-text" translate="x_PrivKeyDesc">
              This is the unencrypted text version of your private key, meaning no password is necessary. If someone were to find your unencrypted private key, they could access your wallet without a password. For this reason, encrypted versions are typically recommended.
              ProTip: If you cannot print this right now, click "Print" and save it as a PDF until you are able to get it printed. Remove it from your computer afterwards!
            </p>
          </div>
        </div>

        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12" ng-show="wallet.type=='default'">
          <div class="input-group row" style="width:100%;">
            <input class="form-control no-animate"
                   type="{{pkeyVisible ? 'text' : 'password'}}"
                   ng-value="wallet.getPrivateKeyString()"
                   readonly="readonly"
                   style="height: 1.5rem;font-size: 1rem;font-family: MoskLight300;color: rgba(20,42,63,1);line-height: 1.5rem;background: transparent;border:none;padding: 0;">
            <span tabindex="0"
                  aria-label="make private key visible"
                  role="button"
                  class="input-group-addon eye"
                  ng-click="showHidePkey()"
                  style="background: transparent;width: 3rem;text-align: center; padding: 0;"></span>
          </div>
          <div class="row" style="margin-top: 1rem;">
            <a class="btn btn-primary" ng-click="printQRCode()" translate="x_Print">
              Print Paper Wallet
            </a>
          </div>          
        </div>

        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-4 text-right">
          <div class="qr-overlay" ng-show="!pkeyVisible"></div>
          <div class="qr-code" qr-code="{{wallet.getPrivateKeyString()}}" watch-var="wallet" width="100%"></div>
          <div class="input-group">
            <input class="form-control no-animate"
                   type="{{pkeyVisible ? 'text' : 'password'}}"
                   ng-value="wallet.getPrivateKeyString()"
                   readonly="readonly"
                   style="display:none;width:0;height:0;padding:0">
            <span tabindex="0"
                  aria-label="make private key visible"
                  role="button" class="input-group-addon eye"
                  ng-click="showHidePkey()"
                  style="width: 100%; display: inherit;"></span>
          </div>
        </div>
      </div>

      <a class="btn btn-default pull-right" ng-click="globalService.currentTab=globalService.tabs.homepage.id">
        <span> Back To Home</span> 
      </a>
    </article>
  </section>
</article>
