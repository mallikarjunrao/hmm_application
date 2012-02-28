$(document).ready(function(){
  /** @location: all pages
      @purpose:  opens and closes the mini-menu sliding drawer **/
  $("#mini-menu").hide();
    $('.open-menu').click(function() {
    //$('#mini-menu').fadeIn("normal");
      $('#mini-menu').slideDown("slow");
    });
    $('.close-menu').click(function() {
    //$('#mini-menu').fadeOut("fast");
      $('#mini-menu').slideUp("slow");
    });

  /** @location: about page, home page
      @purpose:  subtle fade for hero images **/
  $('#photo-gallery').innerfade( {
      animationtype: 'fade',
      speed: 950,
      timeout: 8000,
      type: 'sequence',
      containerheight: '529px'
  });

  /** order form > turn delivery address fieldset on and off **/
  $("#delivery_method_pickup").click(function() {
    $("fieldset#delivery-form").slideUp();  
    $("fieldset#delivery-form").hide();
  });
  $("#delivery_method_delivery").click(function() {
    $("fieldset#delivery-form").slideDown();
    $("fieldset#delivery-form").show();
  });

  /** @location: events1 page
      @purpose:  fade in intro div (at right) **/

  if (!($.browser.msie && $.browser.version <= 6)) { //animate for all browsers but IE6
	  $("#events-page .main img#hero, #events-page .main #details, #events-more-page .main #details, #events-more-page .main img#hero").hide();

	  $("#events-page .main img#hero").fadeIn(1300);
      $("#events-page .main #details").fadeTo(800, 1).fadeIn(1300);
  }//end IE6

  $("#events-more-page .main #details").fadeIn(1500);
  $("#events-more-page .main img#hero").fadeIn(2000);

  /** @location: FAQ page
      @purpose:  open and close question/answer pairs **/
  $(".answer").hide();
  $("#a01").show();

  $(".question").click(function() {
  $(".answer").slideUp();
    $(this).next().slideDown();
    $(this).next().show();
  });

});//end function

/** @purpose: rotates hero images on the homepage **/
(function($) {
    $.fn.innerfade = function(options) {
        return this.each(function() {   
            $.innerfade(this, options);
        });
    };
    $.innerfade = function(container, options) {
        var settings = {
            'animationtype':    'fade',
            'speed':            'normal',
            'type':             'sequence',
            'timeout':          2000,
            'containerheight':  'auto',
            'runningclass':     'innerfade',
            'children':         null
        };
        if (options)
            $.extend(settings, options);
        if (settings.children === null)
            var elements = $(container).children();
        else
            var elements = $(container).children(settings.children);
        if (elements.length > 1) {
            $(container).css('position', 'relative').css('height', settings.containerheight).addClass(settings.runningclass);
            for (var i = 0; i < elements.length; i++) {
                $(elements[i]).css('z-index', String(elements.length-i)).css('position', 'absolute').hide();
            };
            if (settings.type == "sequence") {
                setTimeout(function() {
                    $.innerfade.next(elements, settings, 1, 0);
                }, settings.timeout);
                $(elements[0]).show();
            } else if (settings.type == "random") {
                var last = Math.floor ( Math.random () * ( elements.length ) );
                setTimeout(function() {
                    do { 
                        current = Math.floor ( Math.random ( ) * ( elements.length ) );
                    } while (last == current );             
                    $.innerfade.next(elements, settings, current, last);
                }, settings.timeout);
                $(elements[last]).show();
            } else if ( settings.type == 'random_start' ) {
                settings.type = 'sequence';
                var current = Math.floor ( Math.random () * ( elements.length ) );
                setTimeout(function(){
                  $.innerfade.next(elements, settings, (current + 1) %  elements.length, current);
                }, settings.timeout);
                $(elements[current]).show();
            }  else {
              alert('Innerfade-Type must either be \'sequence\', \'random\' or \'random_start\'');
            }
        }
    };
    $.innerfade.next = function(elements, settings, current, last) {
        if (settings.animationtype == 'slide') {
            $(elements[last]).slideUp(settings.speed);
            $(elements[current]).slideDown(settings.speed);
        } else if (settings.animationtype == 'fade') {
            $(elements[last]).fadeOut(settings.speed);
            $(elements[current]).fadeIn(settings.speed, function() {
              removeFilter($(this)[0]);
            });
        } else
            alert('Innerfade-animationtype must either be \'slide\' or \'fade\'');
        if (settings.type == "sequence") {
            if ((current + 1) < elements.length) {
                current = current + 1;
                last = current - 1;
            } else {
                current = 0;
                last = elements.length - 1;
            }
        } else if (settings.type == "random") {
            last = current;
            while (current == last)
                current = Math.floor(Math.random() * elements.length);
        } else
            alert('Innerfade-Type must either be \'sequence\', \'random\' or \'random_start\'');
        setTimeout((function() {
            $.innerfade.next(elements, settings, current, last);
        }), settings.timeout);
    };

})(jQuery);

// **** remove Opacity-Filter in ie ****
function removeFilter(element) {
  if(element.style.removeAttribute){
    element.style.removeAttribute('filter');
  }
}

/** @purpose: about photo gallery **/
$('#gallery').cycle({ 
    fx:     'fade', 
    prev:   '#prev', 
    next:   '#next', 
    timeout: 0,
  delay:   -2000
});
// hide all but the first image when page loads
$(document).ready(function() {
   $('#gallery .photo:gt(0)').hide();
});

/** @purpose: for the 3rd of 3 wedding/events pages -- this is an image-map like photogallery with a jquery slider ***/
function outputWeddingFlavors(domain) { //cake on left
  pathName = domain + "/images/product/wedding_";
  document.writeln("<div class=\"suggestion\" id=\"ev-1\"><img src=\"" + pathName + "f_choc_on_wh.jpg\" alt=\"wedding/event cupcake sample (suggestion)\" /><h3>fondant white on chocolate</h3></div><div class=\"suggestion\" id=\"ev-2\"><img src=\"" + pathName + "f_wh_on_choc.jpg\" alt=\"wedding/event cupcake sample (suggestion)\" /><h3>fondant chocolate on vanilla</h3></div><div class=\"suggestion\" id=\"ev-3\"><img src=\"" + pathName + "lily.jpg\" alt=\"wedding/event cupcake sample (suggestion)\" /><h3>lily</h3></div><div class=\"suggestion\" id=\"ev-4\"><img src=\"" + pathName + "choc_w_coconut.jpg\" alt=\"wedding/event cupcake sample (suggestion)\" /><h3>coconut</h3></div><div class=\"suggestion\" id=\"ev-5\"><img src=\"" + pathName + "choc_on_vanilla_w_sprinkles.jpg\" alt=\"wedding/event cupcake sample (suggestion)\" /><h3>chocolate on vanilla</h3></div><div class=\"suggestion\" id=\"ev-6\"><img src=\"" + pathName + "vanilla_on_choc.jpg\" alt=\"wedding/event cupcake sample (suggestion)\" /><h3>vanilla on chocolate</h3></div><div class=\"suggestion\" id=\"ev-7\"><img src=\"" + pathName + "vanilla.jpg\" alt=\"wedding/event cupcake sample (suggestion)\" /><h3>vanilla</h3></div><div class=\"suggestion\" id=\"ev-8\"><img src=\"" + pathName + "dark_choc.jpg\" alt=\"wedding/event cupcake sample (suggestion)\" /><h3>dark chocolate sprinkles</h3></div>");
}
function outputMap(domain) { //map on right
  pathName = domain + "/images/product/wedding_";
  document.writeln("<img src=\"" + pathName + "all_suggestions.gif\" alt=\"Cupcake suggestions for your event/wedding\" />");
}

/** @purpose: controls the wedding/event photo gallery (3rd of 3 wedding pages) **/
$(document).ready(function(){
  //set the page
  $(".suggestion").hide();
  $("#ev-1").show();

  //on click events
  $("#thumb-01").click(function() {  $(".suggestion").slideUp(); $(".suggestion").hide();
                  $("#ev-1").slideDown(); $("#ev-1").show(); });
                  
  $("#thumb-02").click(function() {  $(".suggestion").slideUp(); $(".suggestion").hide();
                   $("#ev-2").slideDown(); $("#ev-2").show(); });

  $(".thumb-03").click(function() {  $(".suggestion").slideUp(); $(".suggestion").hide();
                    $("#ev-3").slideDown(); $("#ev-3").show(); });

  $("#thumb-04").click(function() {  $(".suggestion").slideUp(); $(".suggestion").hide();
                   $("#ev-4").slideDown(); $("#ev-4").show(); });

  $("#thumb-05").click(function() {  $(".suggestion").slideUp(); $(".suggestion").hide();
                   $("#ev-5").slideDown(); $("#ev-5").show(); });

  $("#thumb-06").click(function() {  $(".suggestion").slideUp(); $(".suggestion").hide();
                   $("#ev-6").slideDown(); $("#ev-6").show(); });

  $("#thumb-07").click(function() {  $(".suggestion").slideUp(); $(".suggestion").hide();
                   $("#ev-7").slideDown(); $("#ev-7").show(); });

  $("#thumb-08").click(function() {  $(".suggestion").slideUp(); $(".suggestion").hide();
                  $("#ev-8").slideDown(); $("#ev-8").show(); });
});//end function