$(document).ready(function() {
  var SAMPLE_SEARCH_URL_FORMAT = "/get_game?utf8=✓&query=GAMENAME&commit=Search";
  // This will need to be changed if the search URL changes

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
      header: "<h4 class='section-header'>Standalone games</h4>",
      suggestion: function(data) {
        return data.name
        + '<a href="'
        + SAMPLE_SEARCH_URL_FORMAT.replace(/query=(.*)&/, "query="+data.name+"&")
        + '">'
        + '<span class="suggestion-link"></span>'
        + '</a>';
        /*return
        '<a href="/get_game?utf8=✓&query=' + data.name + '&commit=Search">'
        + '<span class="suggestion-link">'
        + '</span>'
        + data.name
        + '</a>';*/
      }
    }
  }, {
    name: 'dlcs_object',
    displayKey: 'name',
    source: dlcs_object.ttAdapter(),
    templates: {
      header: "<h4 class='section-header'>DLCs</h4>"
    }
  });
});