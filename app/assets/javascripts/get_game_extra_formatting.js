$(window).load(function() {
  // PRICES TABLE
  // when clicking a game entry, make its corresponding price appear
  // (and package contents if applicable)
  $(".game-entry").click(function(e) {

    var selected_class = $(e.target).text().replace(/[^\w\d]/g,"-");

    // search for currently selected entries; deselect them
    $(".game-entry").removeClass("selected");
    $(".pricing-entry .selected").removeClass("selected").addClass("unselected");

    // search for classes matching the current selection; select them
    $(e.target).addClass("selected");
    $(".pricing-entry ." + selected_class).removeClass("unselected").addClass("selected");

    // send the ajax request using the game name (ITAD URL can only be found with Ruby)
    if ($(".pricing-entry ." + selected_class + ".ajax-loaded").length)
      console.log("Already loaded " + selected_class);
    else {
      $(".pricing-entry ." + selected_class).addClass("ajax-loaded");

      // ajax request: format the table based on hash received from data.results
      $.post("/ajax/get_prices", // get_prices.json
        { input_name: $(e.target).text() },
        function(data) {
          var output = data.results;
          // console.log(output);

          var outputHTML = "<tr>\
            <th>Vendor</th>\
            <th>Price</th>\
            <th style='width:80px'>Lowest recorded</th>\
          </tr>";

          for (var i = 0; i < output.length; i++) {
            outputHTML += "<tr>\
              <td><a href='" + output[i].store_url + "'>" + output[i].store + "</a></td>\
              <td>" + output[i].current_price + " (" + output[i].price_cut + ")</td>\
              <td>" + output[i].regular_price + "</td>\
            </tr>"
          }

          $(".pricing-entry-inner." + selected_class + " table").append(outputHTML);
        });
    }
  });

  // DESCRIPTION
  $(".collapsed-description").click(function(e) {
    if ($(".description-container")[0].style.maxHeight == "300px")
      $(".description-container")[0].style.maxHeight = "none";
    else
      $(".description-container")[0].style.maxHeight = "300px";
  });

  // IMAGES VIEW
  /*$(".pics-container-outer").mousewheel(function(e, delta) {
    this.scrollLeft -= (delta*40);
    e.preventDefault();
  });*/
  
  function get_images() {
    $.post("/ajax/get_images",
      { input_name: $(".game-name").text() },
      function(data) {
        var images = data.results;
        console.log(images);

        var game_name = $(".game-name").text();
        //var outputHTML = "";
        for (var i = 0; i < images.length; i++) {
          $("#horiz_container").append('<li><a href="' + images[i] + '"\
            class="fancybox"\
            rel="game-images"\
            title="<a href=&quot;' + images[i] + '&quot;>View full resolution</a>">\
            <img src="' + images[i] + '">\
          </a></li>');
        }

        //$("#horiz_container").append(outputHTML);

        // important: if using thumbs, note application.js where
        // =require jquery.fancybox.pack.js comes before =require jquery.fancybox-thumb.js
        $(".fancybox").fancybox({
          prevEffect: 'elastic',
          nextEffect: 'elastic'
        });

        // make sure everything is loaded before trying to set width
        var total_width = 0;
        setTimeout(function() {
          $("#horiz_container li").each(function(index) {
            total_width += parseInt($(this).outerWidth(true), 10);
          });
          console.log(total_width);

          $("#horiz_container").css("width",(total_width+10)+"px"); // +10 for 5px padding on each side
          $("#horiz_container_outer").horizontalScroll();
        }, 500);
      });
  }

  get_images();

  $("#reload-images").click(function(e) {
    $("#horiz_container").empty();
    get_images();
  });
});