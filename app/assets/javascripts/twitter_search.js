var TWITTER_SEARCH_URL = "http://search.twitter.com/search.json";

var TwitterSearch = function( anOnTweetCallback, anOnErrorCallback )
{
  this.myRefreshUrl = "";
  this.myNewTweetCallback = anOnTweetCallback;
  this.myErrorCallback = anOnErrorCallback;

  this.getLatestTweetsForTerm = function(aSearchTerm)
  {
    var theQueryString = "?lang=en&include_entities=true&callback=?&q=" + escape(aSearchTerm);
    $.getJSON(TWITTER_SEARCH_URL + theQueryString, createDelegate(this, this.onSearchComplete));
  };

  this.grabMoreTweets = function()
  {
    $.getJSON(TWITTER_SEARCH_URL + this.myRefreshUrl + "&callback=?", createDelegate(this, this.onSearchComplete));
  }

  this.onSearchComplete = function(aJSON)
  {
    if(aJSON)
    {
      $.each(aJSON.results, this.myNewTweetCallback);
      
      this.myRefreshUrl = aJSON.refresh_url;
    }
    else
    {
      this.myErrorCallback("Woops! There was a problem getting tweets from Twitter..:(")
    }
  }

}
