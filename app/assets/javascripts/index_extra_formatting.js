/*$(window).load(function() {
  // hacky: this eliminates the height difference between game header img height and package image height

  $(".listing-container").imagesLoaded(function() {
    var test_game_existence = $(".game-img").first();
    var test_package_existence = $(".package-img").first();

    if (test_game_existence.length && test_package_existence.length) {
      var game_height = test_game_existence.css("height").replace("px","");
      var package_height = test_package_existence.css("height").replace("px","");
      var final_height = game_height-package_height + "px";

      $(".vertical-spacer").css("height", final_height);
      $(".vertical-spacer-text").css("line-height", final_height);
    }
  });
});*/