<article class=" fade" id="sendTransactionOffline" tabindex="-1" ng-show='sendDealBox'>
    <h2 class="col-xs-11 clearfix sendOffline-step-title">
        <span class="step-item">4</span>
        <span translate="" class="step-caption">Initiate Transaction</span>
      
    </h2>
  <div class="deal-detail">
      <div class="">
          <!-- <button type="button" class="close" data-dismiss="modal" aria-label="Close Dialog">&times;</button>
      
          <h2 class="modal-title text-danger" translate="SENDModal_Title">
            Warning!
          </h2> -->
        <ul class="deal-photo">
          <li class="photo-address clearfix">
              <div ng-show="tx.sendMode=='ether'" class="deal-photo-icon">
                  <div class="addressIdenticon med" title="Address Indenticon" blockie-address="{{tx.from}}" watch-var="tx.from"></div>
              </div>
              <p class="deal-address" ng-show="tx.sendMode=='ether'">
                <span>Output Address</span>
                <span>{{tx.from}}</span>
              </p>
          </li>
          <li class="photo-alt">
            <span class="deal-alt-circle">
                <i class="fa fa-arrow-alt-circle-down"></i>
            </span>
            <span class="deal-coin" ng-show="tx.sendMode=='ether'">
                {{tx.value}} {{unitReadable}}
            </span>
          </li>
          <li class="photo-address clearfix" >
              <div ng-show="tx.sendMode=='ether'" class="deal-photo-icon">
                  <div class="addressIdenticon med" title="Address Indenticon" blockie-address="{{tx.to}}" watch-var="tx.to"></div>
              </div>
              <p class="deal-address" ng-show="tx.sendMode =='ether'">
                  <span>Input Address</span>
                  <span> {{tx.to}}</span>
                </p>
          </li>
        
        </ul>

        <br />

        <p>
          <span translate="SENDModal_Content_1">
            You are about to send
          </span>
          <strong ng-show="tx.sendMode=='ether'" class="mono">
            {{tx.value}} {{unitReadable}}
          </strong>
          <strong ng-show="tx.sendMode!=='ether'" class="mono">
            {{tokenTx.value}} {{unitReadable}}
          </strong>
          <br />
          <span translate="SENDModal_Content_2">
            to address
          </span>
          <strong ng-show="tx.sendMode=='ether'" class="mono">
            {{tx.to}}.
          </strong>
          <strong ng-show="tx.sendMode!=='ether'" class="mono">
            {{tokenTx.to}}
          </strong>
        </p>

        <p>
          The <strong>{{ajaxReq.type}}</strong> node you are sending through is provided by <strong>{{ajaxReq.service}}</strong>.
        </p>

        <h4 translate="SENDModal_Content_3">
          Are you sure you want to do this?
        </h4>

      </div>


      <div class="modal-footer">
        <!-- <button class="btn btn-default" data-dismiss="modal" translate="SENDModal_No">
          No, get me out of here!
        </button> -->
        <button class="btn btn-primary" ng-click="sendTx()" translate="SENDModal_Yes">
          Yes, I am sure! Make transaction.
        </button>
      </div>

    </div>
</article>
