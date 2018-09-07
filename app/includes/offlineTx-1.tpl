<!-- Step 1 -->
<article class="row block sendOffline-step-box clearfix">

    <h2 class="col-xs-11 clearfix sendOffline-step-title" translate="OFFLLINE_Step1_Title">Step 1: Generate Information (Online
      Computer)</h2>
    <div class="clearfix sendOffline-step-content">
      <!-- From Address Input -->
      <section class="col-xs-11 clearfix address-input">
  
        <div class="account-help-icon">
          <!-- <img src="images/icon-help.svg" class="help-icon" />
          <p class="account-help-text" translate="OFFLINE_Step1_Label_2">
            Note: This is the FROM address, not the TO address.
          </p> -->
          <label translate="OFFLINE_Step1_Label_1" class="step-box-title">
            From Address:
          </label>
        </div>
  
        <input class="form-control" type="text" placeholder="0xDECAF9CD2367cdbb726E904cD6397eDFcAe6068D" ng-model="tx.from" ng-change="validateAddress(tx.from,'')"
          ng-class="Validator.isValidAddress(tx.from) ? 'is-valid' : 'is-invalid'" />
  
      </section>
  
  
      <!-- From Address Icon -->
      <section class="col-xs-1 address-identicon-container">
        <div class="addressIdenticon" title="Address Indenticon" blockie-address="{{tx.from}}" watch-var="tx.from"></div>
      </section>
  
  
      <!-- Button -->
      <section class="col-xs-12 clearfix">
        
        <a class="btn btn-info button-next" ng-click="getWalletInfo()">
          <i class="fa fa-book"></i>
          <span  translate="OFFLINE_Step1_Button"> GENERATE INFORMATION</span> 
        </a>
      </section>
  
  
      <section class="clearfix" ng-show="showWalletInfo">
  
        <!-- Gas Price -->
        <div class="col-xs-12 offline-gas-form">
          <label translate="OFFLINE_Step2_Label_3" class="offline-gas-font">
            Gas Price
          </label>
          <input class="form-control offline-gas-font" type="text" placeholder="" readonly="readonly" ng-model="gasPriceDec" />
        </div>
  
        <!-- Nonce -->
        <div class="col-xs-12">
          <label translate="OFFLINE_Step2_Label_5" class="offline-gas-font">
            Nonce
          </label>
          <input class="form-control offline-gas-font" type="text" placeholder="" readonly="readonly" ng-model="nonceDec" />
        </div>
  
      </section>
    </div>
  
  
  </article>
  <!-- / Step 1 -->