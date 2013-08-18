/*jshint asi: true, browser: true, curly: true, eqeqeq: true, forin: false, immed: false, newcap: true, noempty: true, strict: true, undef: true */
/*global jQuery: false, log: true, StyleHatch: true, Spinner: true, gapi: true */

(function( window, $, undefined ){
  'use strict';

  // SCRIPTS TO LOAD ON LIVE BLOGS, NOT INSIDE CUSTOMIZE MENU
  // --------------------------------------------------
  if(!StyleHatch.customizeMode){
    $.getScript('http://platform.twitter.com/widgets.js');
    
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
      po.src = 'https://apis.google.com/js/plusone.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  }

  // BROWSER DETECTION
  // --------------------------------------------------

  // iOS detect
  if( navigator.platform.indexOf( "iPhone" ) !== 0 && navigator.platform.indexOf( "iPad" ) !== 0  && navigator.platform.indexOf( "iPod" ) !== 0  ){
      StyleHatch.iOS = false;
  } else {
      StyleHatch.iOS = true;
  }

  // Firefox detect
  StyleHatch.firefox = testCSS('MozBoxSizing');
  function testCSS(prop) {
      return prop in document.documentElement.style;
  }

  

  // COMMON THEME SPECIFIC JQUERY PLUGINS
  // Some things inside will need to change on a theme to theme basis
  // --------------------------------------------------

  // $.swapHighRes();
  // Assign to photo to swap out for highres if over 500px
  $.fn.swapHighRes = function(){
    var $article = $(this);
    // the calculation might and path to high res might change from theme to theme
    var $container = $article;
    var $image = $article.find('header img');
    
    // stop the proces if it has already been swapped, useful for resize events
    if($image.attr('data-highres-swap')) {
      return true;
    }
    var articleWidth = $container.width();
    if(articleWidth > 500){
      // make sure highres exists
      if($image.attr('data-highres')){
        $image.attr('src', $image.attr('data-highres'));
        $image.attr('data-highres-swap', true);
      }
    }
  }

  // $.swapHighRes();
  // a single, basic plugin to handle all the theme specific setup of the share plugin
  // this prevents the same code pasted in multiple places for index, permalink, infinite scroll
  $.fn.setupTumblrShare = function () {
    return this.each(function () {
      var $share = $(this);
      
      // only render the buttons, look up images, twitter user etc if the div is empty
      // prevents it from being called multiple times even though the jQuery plugin
      // can not be duplicated
      if( $share.is(':empty') ){
        // tumblrShare vars
        // permalink
        var $article = $share.closest('article');
        var sharePermalink = $article.attr('data-permalink');
      
        // smart (by post type) check for images in the post
        var $postImages = $article.find('section img, header img');
        var pinMedia = '';
        var showPinterest = false;
        if($postImages.length > 0){
          // if there are images show pinterest and assign the first image to the media
          showPinterest = true;
          if( $postImages.first().attr('data-highres') ){
            pinMedia = $postImages.first().attr('data-highres');
          } else {
            pinMedia = $postImages.first().attr('src');
          }
        }
      
        // set via to Twitter user only if they have Twitter setup
        var via = '';
        if(StyleHatch.twitterUser){
          via = StyleHatch.twitterUser;
        }
      
        $share.tumblrShare({
          url: sharePermalink,
          media: pinMedia,
          via: via,
          size: 'horizontal',
          pinterest: showPinterest,
          onComplete: function(){
            try{
              gapi.plusone.go();
            } catch(err){
              //log('not there', err);
            }
            $.getScript('http://platform.twitter.com/widgets.js');
            $.getScript('http://assets.pinterest.com/js/pinit.js');
          }
        });
      
      } 
      
    });
  };


  
  // ARTICLE INIT
  // --------------------------------------------------
  $.fn.initArticle = function () {
    // Broad initialization to articles
    var $allArticles = $('article');
    
    // Specific initialization to articles
    return this.each(function (i) {
      var $article = $(this);
      
      // swap out images for high res
      if($article.is('.photo')){
        $article.swapHighRes();
        $article.find('a.highres').colorbox({
          photo:true,
          maxHeight:'95%',
          maxWidth:'98%'
        });
        
      }

      
      // fitVids! Yay!
      if($article.is('.text, .photo, .photoset, .link, .quote, .video, .ask')){
        $article.fitVids();
      }
      
      // Photoset Grid
      var $photosetGrid = $article.find('.photoset-grid');
      if($photosetGrid.length > 0){
        $photosetGrid.find('img').imagesLoaded(function( $images, $proper, $broken ){


          $photosetGrid.photosetGrid({
            layout: $photosetGrid.attr('data-photoset-layout'),
            width: '100%',
            gutter: '0px',
            highresLinks: true,
            lowresWidth: 500,
            rel: $photosetGrid.attr('data-photoset-id'),
            onInit: function(){},
            onComplete: function(){
                $photosetGrid.removeClass('invisible');

                $photosetGrid.find('a').colorbox({
                    photo:true,
                    title: function(){
                      var title = $(this).find('img').attr('alt');
                      $(this).attr('title', title);
                    },
                    maxHeight:'95%',
                    maxWidth:'98%'
                });

                //mediaResize();
            }
          });

          
        });
      }


      // Reblog functionality
      // TODO - test to make sure the paths are correct
      var reblogURL = $article.find('.tumblr-action li.reblog a').attr('href');
      var postID = $article.attr('data-postID');

      $article.find('.tumblr-action li.like').attr('data-reblog', reblogURL);
      $article.find('.tumblr-action li.like').attr('target', '_blank');
      $article.find('.tumblr-action li.like').attr('data-postID', postID);

      $article.find('.tumblr-action li.like a').click(function(e){
        e.preventDefault();

        if(!$('#tumblr-like-frame')[0]){
            // Add like iframe
            $('body').append('<iframe id="tumblr-like-frame" style="display:none;"></iframe>');
        }

        //Like functionality
        var $likeFrame = $('#tumblr-like-frame');
        var liked = $(this).hasClass('tliked');

        var command = liked ? 'unlike' : 'like';
        var postID = $(this).parent().attr('data-postID');
        var reblog = $(this).parent().attr('data-reblog');
        var oauth = reblog.slice(-8);
        var likeURL = 'http://www.tumblr.com/' + command + '/' + oauth + '?id=' + postID;

        if(liked){
          $(this).removeClass('tliked');
        } else {
          $(this).addClass('tliked');
        }
        $likeFrame.attr('src', likeURL);
      });

      if(!StyleHatch.indexPage){
        // paths to share buttons
        var $shareButtons = $article.find('.share-buttons');
        $shareButtons.setupTumblrShare();
      }
      
    });
  }
  $('article').initArticle();


  // ARTICLE INIT EVENTS
  // --------------------------------------------------
  $.fn.initArticleEvents = function(){
    // Broad initialization to articles
    var $allArticles = $(this);
    
    // Specific initialization to articles
    return this.each(function (i){
      var $article = $(this);
      
      // high resolution hover
      if($article.is('.photo')){
        $article.hover(
          function(){
            $(this).find('a.highres').stop(true, false).animate({
              opacity: 1.0
            }, 600, 'easeInOutQuad');
            $(this).find('a.permalink-button').stop(true, false).animate({
              opacity: 1.0
            }, 600, 'easeInOutQuad');
            $(this).find('ul.exif').stop(true, false).animate({
              opacity: 1.0
            }, 600, 'easeInOutQuad');
          },
          function(){
            $(this).find('a.highres').stop(true, false).animate({
              opacity: 0
            }, 200);
            $(this).find('a.permalink-button').stop(true, false).animate({
              opacity: 0
            }, 200);
            $(this).find('ul.exif').stop(true, false).animate({
              opacity: 0.4
            }, 200);
          }
        );
      }
      
    });
  }
  $('article').initArticleEvents();

  // RESIZE EVENTS
  // --------------------------------------------------

  // Lock the navigation bar once you scroll down below the header
  if( $('header.site-info nav.pages ul').length){

    // Create a container for the duplicate nav
    $('body').append('<header class="site-fixed" />');

    // If it isn't a mobile device
    if($('header.site-fixed').css('visibility') !== 'hidden'){

      // Duplicate the nav bar for the locked state
      $('header.site-info nav.pages').clone().appendTo('header.site-fixed');

      // Add burger 
      //$('header.site-fixed nav.pages ul').prepend('<li class="view-nav"><a href="#"><span class="icon-menu-2"></span></a></li>');

      // Throttle scroll functions by setting var and interval check
      var hasScrolled = false;
      var locked;
      var $header = $('header.site-info .container');
      var $fixedNavBar = $('header.site-fixed');


      $(window).scroll(function(){
        hasScrolled = true;
      });
      setInterval(function(){
        if(hasScrolled){
          hasScrolled = false;

          if( !locked && ( $(this).scrollTop() >= $header.height() ) ){
            $fixedNavBar.fadeIn(200);
            $('#tumblr_controls').addClass('below-nav');
            locked = true;
          } else if ( locked && ( $(this).scrollTop() < $header.height() ) ) {
            $fixedNavBar.hide();
            $('#tumblr_controls').removeClass('below-nav');
            locked = false;
          }

        }
      }, 5);
      
    }
  }

  


  // INFINITE SCROLLING
  // --------------------------------------------------
  if(StyleHatch.infiniteScroll && StyleHatch.indexPage && !$('html').hasClass('ie6') && !$('html').hasClass('ie7') && !$('html').hasClass('ie7')){
      $('#infinite').addClass('show');
      $('.posts').infinitescroll({

          navSelector  : '#infinite',
          nextSelector : '#infinite a',
          itemSelector : '.posts article, hr',
          // path         : ['/page/', '/'],
          bufferPx     : 400,
          debug        : false,
          errorCallback: function() {
              
              $('#infinite a').html(StyleHatch.noMoreText);
              $('#infinite').delay(1000).slideUp(300);
              setTimeout(function(){
                  $('#infinite').removeClass('show');
              }, 1300);

          }
      }, function(newElements){

          
          $(newElements).initArticle();
          $(newElements).initArticleEvents();
          

          if(StyleHatch.disqusID){
              var disqus_shortname = StyleHatch.disqusID;
              (function () {
                  var s = document.createElement('script'); s.async = true;
                  s.type = 'text/javascript';
                  s.src = 'http://' + disqus_shortname + '.disqus.com/count.js';
                  (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
              }());
          }

      });

      // Make the first load manual, all others automatic
      $('#infinite-spin').hide();
      $('.posts').infinitescroll('pause');
      $('#infinite a').click(function(e){
          e.preventDefault();

          $('#infinite a.button span.label').html(StyleHatch.loadingText);
          $('#infinite-spin').show();
          $('#infinite a.button').css({
            'padding-left': '2.25em'
          });

          $('.posts').infinitescroll('retrieve');
          $('.posts').infinitescroll('resume');
      });
  }

  var opts = {
    lines: 14, // The number of lines to draw
    length: 1, // The length of each line
    width: 2, // The line thickness
    radius: 5, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: StyleHatch.textOnAccent, // #rgb or #rrggbb
    speed: 1.6, // Rounds per second
    trail: 100, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: 'auto', // Top position relative to parent in px
    left: 'auto' // Left position relative to parent in px
  };
  var target = document.getElementById('infinite-spin');
  var spinner = new Spinner(opts).spin(target);

  // Backstretch - Page BG
  if(StyleHatch.fillSite){
      // Check to make sure an image was loaded
      if(StyleHatch.siteBackground){
          $.backstretch(StyleHatch.siteBackground);
      }
  }

  // Backstretch - Header BG
  if(StyleHatch.fillHeader){
      // Check to make sure an image was loaded
      if(StyleHatch.headerBackground){
          $('header.site-info').backstretch(StyleHatch.headerBackground);
      }
  }


  // LOAD EXTERNAL DATA
  // --------------------------------------------------
  //Instagram integration
  StyleHatch.instagramCount = 4;
  if(StyleHatch.instagramToken){
      var $instagram = $('section.instagram');
      $.ajax({
      url: "https://api.instagram.com/v1/users/self/media/recent/?access_token=" + StyleHatch.instagramToken + "&count=" + StyleHatch.instagramCount,
      dataType: "jsonp",
      timeout: 5000,
      success: function(data) {
        $instagram.find('ul').empty();
        for (var i = 0; i < StyleHatch.instagramCount; i++) {
          $instagram.find('ul').append('<li><a href="' + data.data[i].link + '" target="_blank"><img src="' + data.data[i].images.low_resolution.url + '" /></a></li>');
        }
        var instagramFeed = 'http://www.instagram.com/' + data.data[0].user.username;
        $instagram.find('a.btn').attr('href', instagramFeed);
      }
      });
  }
  
  // CUSTOMIZE MENU
  // --------------------------------------------------
  
  if(StyleHatch.customizeMode){
    $('section.liked-posts').hide();
    $('.audio_player').addClass('customize-audio black');
    $('.fluid-width-video-wrapper').addClass('customize-embed');
  }

})( window, jQuery );