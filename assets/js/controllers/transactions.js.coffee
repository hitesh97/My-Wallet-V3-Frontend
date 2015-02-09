@TransactionsCtrl = ($scope, Wallet, MyWallet, $log, $stateParams, $timeout, $state) ->
  
  $scope.nextPage = () ->
    return if $scope.allTransactionsLoaded
    $scope.loading = true
    
    success = () ->
      $scope.loading = false
      
    error = () ->
      $scope.loading = false
      
    allTransactionsLoaded = () ->
      $scope.allTransactionsLoaded = true
      $scope.loading = false
      
    
    Wallet.fetchMoreTransactions($stateParams.accountIndex, success, error, allTransactionsLoaded)
  
  $scope.showTransaction = (transaction) ->
    $state.go("wallet.common.transaction", {accountIndex: $scope.accountIndex, hash: transaction.hash})
  
  #################################
  #           Private             #
  #################################
  

  
  $scope.$watchCollection "accounts", (newValue) ->
    if $scope.accounts.length > 0
      $scope.canDisplayDescriptions = true
      
    
  $scope.didLoad = () ->    
    $scope.transactions = Wallet.transactions      
    $scope.addressBook = Wallet.addressBook
    $scope.status    = Wallet.status
    $scope.settings = Wallet.settings
    $scope.totals = Wallet.totals  
    $scope.accountIndex = $stateParams.accountIndex
    $scope.accounts = Wallet.accounts
    $scope.canDisplayDescriptions = false # Don't try to show descriptions for before accounts have been loaded
    $scope.allTransactionsLoaded = false
    if $stateParams.accountIndex == "accounts"
      # Pending implementation:
      $scope.allTransactionsLoaded = true
        
  $scope.transactionFilter = (item) ->
    return item.to.account? || item.from.account? if $stateParams.accountIndex == "accounts"
    return !item.to.account? && !item.from.account? if $stateParams.accountIndex == "imported"
    return (item.to.account? && item.to.account.index == parseInt($stateParams.accountIndex)) || (item.from.account? && item.from.account.index == parseInt($stateParams.accountIndex))
  
  $scope.$watch "status.didLoadTransactions", (newValue) ->
     $scope.loading = !newValue
  
  # First load:      
  $scope.didLoad()
  
