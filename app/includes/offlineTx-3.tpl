<article class="row sendOffline-step-box clearfix">

    <h2 translate="OFFLINE_Step3_Title" class="col-xs-11 clearfix sendOffline-step-title">
      Step 3: Send / Publish Transaction
    </h2>
  
    <!-- <p translate="OFFLINE_Step3_Label_1">
          Paste the signed transaction from Step 2
        </p>  -->
    <div class="sendOffline-step-content clearfix">
        <div class="col-sm-6 col-xs-12">
            <!-- -->
            <label translate="SEND_signed" class="step-box-title">
              Signed Transaction
            </label>
            <textarea class="form-control" rows="7" ng-model="signedTx"></textarea>
            <a class="btn btn-primary" ng-click="confirmSendTx()" translate="SEND_trans">
              SEND TRANSACTION
            </a>
          </div>
        
          <div class="col-sm-6 col-xs-12">
            <div class="qr-code" qr-code="{{signedTx}}" watch-var="signedTx" width="100%" style="  max-width: 20rem; margin: 1rem auto;"></div>
          </div>
        
    </div>
    
  </article>