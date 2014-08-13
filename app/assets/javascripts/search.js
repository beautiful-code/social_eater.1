$(document).on('ready page:load', function() {
    var results;
  console.log('AAAAA');
  results = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/searches/search?search=%QUERY'
    }
  });
  results.initialize();
return $('input.typeahead').typeahead({
  hint: true,
  highlight: true,
  minLength: 2
}, {
  name: 'articles',
  displayKey: 'name',
  source: results.ttAdapter()
});
});
