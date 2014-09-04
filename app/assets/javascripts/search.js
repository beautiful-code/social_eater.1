$(document).on('ready page:load', function() {
    var results;
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
        minLength: 1
    }, {
        name: 'articles',
        displayKey: 'name',
        source: results.ttAdapter(),
        templates: {
            empty: [
                '<div class="empty-message">',
                'unable to find any places/items',
                '</div>'
            ].join('\n'),
            suggestion: Handlebars.compile('<p><strong>{{name}}</strong> – {{kind}}</p>')
        }

    });
});
