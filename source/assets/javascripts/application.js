//= require ./vendor/jquery
//= require ./vendor/isotope.pkgd.js
//= require_tree ./lib
//= require ./viz.js


$(document).ready(function(){
  // $('.navbar-nav a').smoothScroll();

  $('.viz-isotope').isotope({
      layoutMode: 'masonry',
      itemSelector: '.item',
      isInitLayout: true,
      masonry: {
          columnWidth: '.grid-sizer',
        }
    }).isotope('layout');

    $('.viz-isotope').isotope( 'on', 'layoutComplete', function() {
      console.log('layout is complete');
    });

});
//  /= require bootstrap-sprockets
