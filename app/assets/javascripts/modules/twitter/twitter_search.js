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

    this.callTwitterAjax( theQueryString );
  };
  
  this.abort = function()
  {
    this.myAbortFlag = true;
    this.myRefreshUrl = "";
  }
  
  this.grabMoreTweets = function()
  {
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.callTwitterAjax( this.myRefreshUrl );
  };
  
  this.onSearchSuccess = function(aJSON, aTextStatus, aJqHR)
  {
    if (this.myAbortFlag)
    {
      return;
    }

    if(aJSON && aJSON.results)
    {
      this.myListener.onNewTweets(aJSON.results);
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
  };
  
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
  
  this.onComplete = function( aJqHR, aTextStatus )
  {
    if ( aTextStatus == "success")
    {
      this.myListener.onSuccess();      
    }
    else
    {
      this.myListener.onError("Woops! There was a problem getting tweets from Twitter: " + aTextStatus ); 
    }
  };
  
  this.onError = function(aJqXHR, aTextStatus, anErrorThrown)
  {
    console.log(anErrorThrown);
    this.myListener.onError("Woops! There was a problem getting tweets from Twitter: " + aTextStatus );
  };

  this.callTwitterAjax = function( aUrl )
  {
    try
    {
      $.ajax(
      {
        url: TWITTER_SEARCH_URL + aUrl,
        cache:false,
        dataType: "jsonp",
        success: createDelegate(this, this.onSearchSuccess),
        complete: createDelegate(this, this.onComplete),
        error: createDelegate(this, this.onError )
      });
    }
    catch(anError)
    {
      console.log(anError);
      this.myListener.onError("Woops! There was a problem getting tweets from Twitter: " + anError );
    }
  };
}
