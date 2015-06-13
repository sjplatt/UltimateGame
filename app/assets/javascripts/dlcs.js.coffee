$ ->
  $('#game_search').typeahead
    name: "dlc"
    remote: "/dlcs/autocomplete?query=%QUERY"