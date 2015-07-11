var search = function() {
  var SAMPLE_SEARCH_URL_FORMAT = "/get_game?utf8=✓&query=GAMENAME&commit=Search&dlc=DLCBOOL";
  // This will need to be changed if the search URL changes

  var bloodhound_remote_filter = function(is_dlc_param) {
    return function(results) {
      // console.log(results);
      return $.map(results, function(data) {
        return {
          name: data,
          sanitized_name: data
            .replace(/[^a-zA-Z0-9\s]/g, "")
            .replace(/\-/g, "")
            .replace(/\s+/, " "),
          is_dlc: is_dlc_param
        };
        // add whatever you want to display here
      });
    }
  };

  var games_object = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.nonword,
    queryTokenizer: Bloodhound.tokenizers.nonword,
    // limit: 8,
    remote: {
      url: '/games/autocomplete?query=%QUERY',
      filter: bloodhound_remote_filter(false)
    }
  });
  var dlcs_object = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.nonword,
    queryTokenizer: Bloodhound.tokenizers.nonword,
    remote: {
      url: '/dlcs/autocomplete?query=%QUERY',
      filter: bloodhound_remote_filter(true)
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

  function get_search_url(name,is_dlc_param) {
    if (is_dlc_param) {
      return SAMPLE_SEARCH_URL_FORMAT
          .replace("GAMENAME", name)
          .replace("DLCBOOL", "true") + "#dlc-info";
    }
    else {
      return SAMPLE_SEARCH_URL_FORMAT
        .replace("GAMENAME", name)
        .replace("DLCBOOL", "false");
    }
  }

  var typeahead_suggestion = function(is_dlc_param) {
    return function(data) {
      return data.name
      /*+ '<a href="'
      + get_search_url(data.name,is_dlc_param)
      + '">'*/
      + '<span class="suggestion-link"></span>'
      + '</a>';
    }
  }

  $('.typeahead').typeahead({
    highlight: true,
    minLength: 2,
    autoselect: true
  }, {
    name: 'games',
    displayKey: 'name',
    source: games_object.ttAdapter(),
    templates: {
      header: "<h4 class='section-header'>Standalone games</h4>",
      empty: "<span class='empty-suggestions'>(no suggestions found)</span>",
      suggestion: typeahead_suggestion(false)
    }
  }, {
    name: 'dlcs',
    displayKey: 'name',
    source: dlcs_object.ttAdapter(),
    templates: {
      header: "<h4 class='section-header'>DLCs</h4>",
      empty: "<span class='empty-suggestions'>(no suggestions found)</span>",
      suggestion: typeahead_suggestion(true)
    }
  }).on("typeahead:selected", function(ev, suggestion) {
    //console.log(suggestion);
    window.location = get_search_url(suggestion.name,suggestion.is_dlc)
  });
}

$(document).ready(search);
$(document).on("page:load", search);
// for turbolinks to reload javascript when returning to homepage