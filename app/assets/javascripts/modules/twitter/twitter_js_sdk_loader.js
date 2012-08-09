$(function()
{
  window.twttr = ( function(d, s, id)
    {
      var t, js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id))
        return;
      js = d.createElement(s);
      js.id = id;
      js.src = "//platform.twitter.com/widgets.js";
      fjs.parentNode.insertBefore(js, fjs);
      return window.twttr || ( t =
      {
        _e : [],
        ready : function(f)
        {
          t._e.push(f)
        }
      });
    }(document, "script", "twitter-wjs"));
    
  // Wait for the asynchronous resources to load
  twttr.ready(function(twttr)
  {
    // Now bind our custom intent events
    twttr.events.bind('click', clickEventToAnalytics);
    twttr.events.bind('tweet', tweetIntentToAnalytics);
    twttr.events.bind('retweet', retweetIntentToAnalytics);
    twttr.events.bind('favorite', favIntentToAnalytics);
    twttr.events.bind('follow', followIntentToAnalytics);
  });
    
});

// Define our custom event hanlders
function clickEventToAnalytics(intent_event)
{
  if (intent_event)
  {
    var label = intent_event.region;
    pageTracker._trackEvent('twitter_web_intents', intent_event.type, label);
  };
}

function tweetIntentToAnalytics(intent_event)
{
  if (intent_event)
  {
    var label = "tweet";
    pageTracker._trackEvent('twitter_web_intents', intent_event.type, label);
  };
}

function favIntentToAnalytics(intent_event)
{
  tweetIntentToAnalytics(intent_event);
}

function retweetIntentToAnalytics(intent_event)
{
  if (intent_event)
  {
    var label = intent_event.data.source_tweet_id;
    pageTracker._trackEvent('twitter_web_intents', intent_event.type, label);
  };
}

function followIntentToAnalytics(intent_event)
{
  if (intent_event)
  {
    var label = intent_event.data.user_id + " (" + intent_event.data.screen_name + ")";
    pageTracker._trackEvent('twitter_web_intents', intent_event.type, label);
  };
}

