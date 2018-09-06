

<section class="swap-panel" ng-show="showStage3Eth && orderResult.progress.status=='OPEN'">
    <div class="alert alert-danger" ng-show="ajaxReq.type!=='ETH'">
        <strong>Warning! You are not connected to an ETH node.</strong> <br/> Please use the node switcher in the top-right
        corner to switch to an ETH node. We <strong>do not
        </strong> support swapping ETC or Testnet ETH.
    </div>

    <section class="" ng-show="wallet!=null " ng-controller='sendTxCtrl'>
        @@if (site === 'mew' ) { @@include( './sendTx-content.tpl', { "site": "mew" } ) } @@if (site === 'cx' ) { @@include( './sendTx-content.tpl',
        { "site": "cx" } ) } @@if (site === 'mew' ) { @@include( './sendTx-modal.tpl', { "site": "mew" } ) } @@if (site ===
        'cx' ) { @@include( './sendTx-modal.tpl', { "site": "cx" } ) }
    </section>
</section>