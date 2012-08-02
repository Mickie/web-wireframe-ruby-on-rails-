var TWITTER_SEARCH_URL = "http://search.twitter.com/search.json";

var TwitterSearch = function( aListener )
{
  this.myRefreshUrl = "";
  this.myListener = aListener;
  this.myAbortFlag = false;

  this.getLatestTweetsForTerm = function(anArrayOfHashTags, anArrayOfNotTags, aNumberToGet)
  {
    this.myAbortFlag = false;

    var theSearchQuery = this.getSearchQuery(anArrayOfHashTags, anArrayOfNotTags);
    var theQueryString = "?lang=en&include_entities=true&q=" + escape(theSearchQuery) + "&rpp=" + aNumberToGet;
    $.ajax({
             url: TWITTER_SEARCH_URL + theQueryString,
             cache:false,
             dataType: "jsonp",
             success: createDelegate(this, this.onSearchComplete)
           });
  };
  
  this.abort = function()
  {
    this.myAbortFlag = true;
    this.myRefreshUrl = "";
  }
  
  this.getSearchQuery = function( anArrayOfHashTags, anArrayOfNotTags )
  {
    var theQuery = $.trim(anArrayOfHashTags[0])
    var i = 0;
    
    for (i=1; i < anArrayOfHashTags.length; i++) 
    {
      theQuery += " OR " + $.trim(anArrayOfHashTags[i]);
    };
    
    for (i=0; i < anArrayOfNotTags.length; i++) 
    {
      theQuery += " -" + $.trim(anArrayOfNotTags[i]);
    };
    return theQuery;
  };

  this.grabMoreTweets = function()
  {
    if (this.myAbortFlag)
    {
      return;
    }
    $.getJSON(TWITTER_SEARCH_URL + this.myRefreshUrl + "&callback=?", 
              createDelegate(this, this.onSearchComplete));
  }
  
  this.onSearchComplete = function(aJSON, aTextStatus, aJqHR)
  {
    if (this.myAbortFlag)
    {
      return;
    }

    if(aJSON && aJSON.results)
    {
      $.each(aJSON.results, createDelegate( this.myListener, this.myListener.onNewTweet ) );
      
      this.myRefreshUrl = aJSON.refresh_url;
    }
    else
    {
      console.log("aJSON:");
      console.log(aJSON);
      console.log("aJqHR:");
      console.log(aJqHR);
      this.myListener.onError("Woops! There was a problem getting tweets from Twitter: " + aTextStatus );
    }
  }

}
