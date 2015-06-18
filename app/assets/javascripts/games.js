$(document).ready(function() {
  var SAMPLE_SEARCH_URL_FORMAT = "/get_game?utf8=✓&query=GAMENAME&commit=Search&dlc=DLCBOOL";
  // This will need to be changed if the search URL changes

  var games_object = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.nonword,
    queryTokenizer: Bloodhound.tokenizers.nonword,
    // limit: 8,
    remote: {
      url: '/games/autocomplete?query=%QUERY',
      filter: function(results) {
        // console.log(results);
        return $.map(results, function(data) {
          return {
            "name": data,
            "sanitized_name": data
              .replace(/[^a-zA-Z0-9\s]/g, "")
              .replace(/\-/g, "")
              .replace(/\s+/, " ")
          };
          // add whatever you want to display here
        });
      },
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
    minLength: 2
  }, {
    name: 'games',
    displayKey: 'name',
    source: games_object.ttAdapter(),
    templates: {
      header: "<h4 class='section-header'>Standalone games</h4>",
      empty: "<span class='empty-suggestions'>(no suggestions found)</span>",
      suggestion: function(data) {
        return data.name
        + '<a href="'
        + SAMPLE_SEARCH_URL_FORMAT
          .replace("GAMENAME", data.name)
          .replace("DLCBOOL", "false")
        + '">'
        + '<span class="suggestion-link"></span>'
        + '</a>';
      }
    }
  }, {
    name: 'dlcs',
    displayKey: 'name',
    source: dlcs_object.ttAdapter(),
    templates: {
      header: "<h4 class='section-header'>DLCs</h4>",
      empty: "<span class='empty-suggestions'>(no suggestions found)</span>",
      suggestion: function(data) {
        return data.name
        + '<a href="'
        + SAMPLE_SEARCH_URL_FORMAT
          .replace("GAMENAME", data.name)
          .replace("DLCBOOL", "true")
        + '">'
        + '<span class="suggestion-link"></span>'
        + '</a>';
      }
    }
  });
});