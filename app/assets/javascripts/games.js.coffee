$ ->
  $('#game_search').typeahead
    name: "game"
    remote: "/games/autocomplete?query=%QUERY"