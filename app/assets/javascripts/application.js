// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// update config/environments/production.rb with other files you want to also include in addition to this one
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require facebook_js_sdk_loader
//= require google_analytics
//= require twitter_search
//= require twitter_view

function createDelegate(anObject, aMethod)
{
  var theDelegate = function()
  {
    return aMethod.apply(anObject, arguments);
  }
  return theDelegate;
}
