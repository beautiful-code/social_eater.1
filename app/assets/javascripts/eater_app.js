var app = angular.module('eaterApp', []);

app.controller('NotesListCtrl', ['$scope',function ($scope) {


  $scope.addItem = function() {
    $scope.notes.push([$scope.new_note_item, $scope.new_note_cold_votes]);

    $scope.new_note_item = '';
    $scope.new_note_cold_votes = 1;
  };

  $scope.show_submit_button = function() {
    return ($scope.notes.length > 0);
  };

  $scope.notes = [];
  $scope.new_note_cold_votes = 1;
  
}]);


app.controller('NoteCtrl', ['$scope',function ($scope) {

  $scope.upVote = function() {
    var note_index = $scope.$index;
    $scope.notes[note_index][1]++;
  };

  $scope.downVote = function() {
    var note_index = $scope.$index;
    $scope.notes[note_index][1]--;
  };

  $scope.deleteNote = function() {
    var index = $scope.$index;
    $scope.notes.splice($scope.$index, 1);
  };

  
}]);
