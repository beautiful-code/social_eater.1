String.prototype.titleize = function() {
  var words = this.split(' ')
  var array = []
  for (var i=0; i<words.length; ++i) {
    array.push(words[i].charAt(0).toUpperCase() + words[i].toLowerCase().slice(1))
  }
  return array.join(' ')
};

//Sorting function based on the first item in an array
function compare(a,b) {
  if (a[0] < b[0])
     return -1;
  if (a[0] > b[0])
    return 1;
  return 0;
}

//Sorting function based on the first item in an array
function position_compare(a,b) {
  if (a[1] < b[1])
     return -1;
  if (a[1] > b[1])
    return 1;
  return 0;
}
