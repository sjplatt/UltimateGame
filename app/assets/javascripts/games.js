$(document).ready(function() {
  var games_object = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.nonword,
    queryTokenizer: Bloodhound.tokenizers.nonword,
    remote: {
      url: '/games/autocomplete?query=%QUERY',
      filter: function(results) {
        // console.log(results);
        return $.map(results, function(data) {
          return {name: data};
          // add whatever you want to display here
        });
      }
    }
  });
  var dlcs_object = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.nonword,
    queryTokenizer: Bloodhound.tokenizers.nonword,
    remote: {
      url: '/dlcs/autocomplete?query=%QUERY',
      filter: function(results) {
        // console.log(results);
        return $.map(results, function(data) {
          return {name: data};
          // add whatever you want to display here
        });
      }
    }
  });

  var games_promise = games_object.initialize();
  var dlcs_promise = dlcs_object.initialize();

  games_promise
    .done(function() { console.log('games searcher - success!'); })
    .fail(function() { console.log('games searcher - error!'); });
  dlcs_promise
    .done(function() { console.log('dlcs searcher - success!'); })
    .fail(function() { console.log('dlcs searcher - error!'); });

  $('#game_search').typeahead({
    highlight: true,
    minLength: 2,
    hint: true,
    items: 5
  }, {
    name: 'games_object',
    displayKey: 'name',
    source: games_object.ttAdapter(),
    templates: {
      header: "<h4>Standalone games</h4>"
    }
  }, {
    name: 'dlcs_object',
    displayKey: 'name',
    source: dlcs_object.ttAdapter(),
    templates: {
      header: "<h4>DLCs</h4>"
    }
  });
});