var app = angular.module('demoApp', []);
//在测试之前要先引入angular以及对应版本的angular-mock
app.controller('test1Ctrl', function($scope) {
    $scope.name = "app"

    $scope.num = 0;
    $scope.incrementNum = function() {
        $scope.num++;
    }
})