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
      get_prices(selected_class, $(e.target).text());
    }
  });

  function get_prices(selected, input_name_text) {
    $(".pricing-entry-inner." + selected).append('<div class="price-loading-overlay">\
      <img src="/assets/fancybox_loading.gif" />\
      Loading prices...<br>');/*(Taking too long? <a class="reload-prices">Reload this view</a>)\
    </div>');*/

    // ajax request: format the table based on hash received from data.results
    $.post("/ajax/get_prices", // get_prices.json
      { input_name: input_name_text },
      function(data) {
        var output = data.results;
        // console.log(output);

        var outputHTML = '<tr>\
          <th>Vendor</th>\
          <th>Price</th>\
          <th style="width:80px">Lowest recorded</th>\
        </tr>';

        for (var i = 0; i < output.length; i++) {
          outputHTML += '<tr>\
            <td><a href="' + output[i].store_url + '">' + output[i].store + '</a></td>\
            <td>' + output[i].current_price + ' (' + output[i].price_cut + ')</td>\
            <td>' + output[i].regular_price + '</td>\
          </tr>'
        }

        $(".pricing-entry-inner." + selected + " .price-loading-overlay").remove();
        $(".pricing-entry-inner." + selected + " table").append(outputHTML);
      });
  }

  $(".reload-prices").click(function(e) {
    // placeholder for possible reload price functionality
  })



  // IMAGES VIEW
  /*$(".pics-container-outer").mousewheel(function(e, delta) {
    this.scrollLeft -= (delta*40);
    e.preventDefault();
  });*/
  
  function get_images() {
    $("#horiz_container_outer").prepend('<div class="img-loading-overlay">\
      <div class="img-loading-overlay-inner">\
        <img src="/assets/fancybox_loading.gif" />\
        Loading images...\
      </div>\
    </div>');

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
            <img src="' + images[i] + '" alt="">\
          </a></li>');
        }

        //$("#horiz_container").append(outputHTML);
        $(".img-loading-overlay").hide(300);
        $(".img-loading-overlay").remove();

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

          $("#horiz_container").css("width",(total_width+12)+"px"); // +10 for 5px padding on each side
          $("#dragBar").css("display","block");
          $("#horiz_container_outer").horizontalScroll();
        }, 1000);

        if (!$.trim($("#horiz_container").html())) {
          $("#horiz_container_outer").prepend('<div class="img-loading-overlay">\
            <div class="img-loading-overlay-inner">\
              Sorry, image loading failed. <a class="reload-images">Reload images</a>\
            </div>\
          </div>');
        }
      });
  }

  get_images();

  $(".reload-images").click(function(e) {
    $("#horiz_container").empty();
    get_images();
  });



  // DESCRIPTION
  $(".collapse-description").click(function(e) {
    if ($(".description-container").css("max-height") === "300px")
      $(".description-container").css("max-height","none");
    else
      $(".description-container").css("max-height","300px");
  });
});