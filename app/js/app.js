angular.module("app", ["customFilters", "cart", "ngRoute"]);

angular.module("app")
.constant("dataUrl", "http://localhost:8000/api/products")
.controller("sportsStoreCtrl", function($scope, $http, dataUrl) {
    $scope.data = {};

    $http.get(dataUrl)
    .success(function (data) {
	$scope.data.products = data;
    })
    .error(function (error) {
	$scope.data.error = error;
    })

});
