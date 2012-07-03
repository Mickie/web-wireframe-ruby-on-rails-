var TWITTER_SEARCH_URL = "http://search.twitter.com/search.json";

var TwitterSearch = function( anOnTweetCallback, anOnErrorCallback )
{
  this.myRefreshUrl = "";
  this.myNewTweetCallback = anOnTweetCallback;
  this.myErrorCallback = anOnErrorCallback;

  this.getLatestTweetsForTerm = function(anArrayOfHashTags, anArrayOfNotTags, aNumberToGet)
  {
    var theSearchQuery = this.getSearchQuery(anArrayOfHashTags, anArrayOfNotTags);
    var theQueryString = "?lang=en&include_entities=true&q=" + escape(theSearchQuery) + "&rpp=" + aNumberToGet;
    $.ajax({
             url: TWITTER_SEARCH_URL + theQueryString,
             cache:false,
             dataType: "jsonp",
             success: createDelegate(this, this.onSearchComplete)
           });
  };
  
  this.getSearchQuery = function( anArrayOfHashTags, anArrayOfNotTags )
  {
    var theQuery = anArrayOfHashTags.join(" OR ");
    for (var i=0; i < anArrayOfNotTags.length; i++) 
    {
      theQuery += " -" + $.trim(anArrayOfNotTags[i]);
    };
    return theQuery;
  };

  this.grabMoreTweets = function()
  {
    var theCacheBuster = new Date().getTime();
    $.getJSON(TWITTER_SEARCH_URL + this.myRefreshUrl + "&callback=?&cb=" + theCacheBuster, 
              createDelegate(this, this.onSearchComplete));
  }
  
  this.onSearchComplete = function(aJSON, aTextStatus, aJqHR)
  {
    if(aJSON && aJSON.results)
    {
      $.each(aJSON.results, this.myNewTweetCallback);
      
      this.myRefreshUrl = aJSON.refresh_url;
    }
    else
    {
      console.log("aJSON:");
      console.log(aJSON);
      console.log("aJqHR:");
      console.log(aJqHR);
      this.myErrorCallback("Woops! There was a problem getting tweets from Twitter: " + aTextStatus );
    }
  }

}
