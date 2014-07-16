var app = angular.module('eaterApp', []);

app.controller('NotesCtrl', ['$scope',function ($scope) {


  $scope.addItem = function() {
    $scope.items.push([$scope.new_item.trim().titleize(), $scope.new_item_cold_votes]);
    $scope.items = $scope.items.sort(compare);

    $scope.new_item = '';
    $scope.new_item_cold_votes = 1;
  };

  $scope.addCategory = function() {
    $scope.categories.push([$scope.new_category_name.trim().titleize(), $scope.new_category_position]);
    $scope.categories = $scope.categories.sort(compare);

    $scope.new_category_name = '';
    $scope.new_category_position = 0;
  };

  $scope.doNothing = function() {};

  $scope.items = PageConfig.items.sort(compare);
  $scope.new_item_cold_votes = 1;

  $scope.categories = PageConfig.categories.sort(compare);
  $scope.new_category_position = 0;
  
}]);


app.controller('ItemCtrl', ['$scope',function ($scope) {

  $scope.upVote = function() {
    $scope.items[$scope.$index][1]++;
  };

  $scope.downVote = function() {
    var item_index = $scope.$index;
    $scope.items[$scope.$index][1]--;
  };

  $scope.deleteNote = function() {
    $scope.items.splice($scope.$index, 1);
  };

  
}]);


app.controller('CategoryCtrl', ['$scope',function ($scope) {

  $scope.deleteCategory = function() {
    $scope.categories.splice($scope.$index, 1);
  };
  
}]);

app.directive('ngEnter', function () {
    return function (scope, element, attrs) {
        element.bind("keydown keypress", function (event) {
            if(event.which === 13) {
                scope.$apply(function (){
                    scope.$eval(attrs.ngEnter);
                });

                event.preventDefault();
            }
        });
    };
});