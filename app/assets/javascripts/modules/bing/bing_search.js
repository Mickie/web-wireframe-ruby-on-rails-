var BingSearch = function( aListener )
{
  this.myCurrentTeamId;
  this.myListener = aListener;
  this.myAbortFlag = false;
  
  this.getSearchResultsForTeam = function( aTeamId )
  {
    this.myCurrentTeamId = aTeamId;
    this.myListener = aListener;
    
    this.callBingAjax( this.getSearchQuery(this.myCurrentTeamId) );
  };
  
  this.abort = function()
  {
    this.myAbortFlag = true;
  };
  
  this.getSearchQuery = function(anId)
  {
    return "/teams/" + anId + "/bing_search_results.json";
  }
  
  this.parseResults = function (aResultsObject)
  {
    if (aResultsObject.Video.length > 0)
    {
      $.each(aResultsObject.Video, createDelegate( this.myListener, this.myListener.onBingVideo ) );
    }
    
    if (aResultsObject.Image.length > 0)
    {
      $.each(aResultsObject.Image, createDelegate( this.myListener, this.myListener.onBingImage ) );
    }

    if (aResultsObject.News.length > 0)
    {
      $.each(aResultsObject.News, createDelegate( this.myListener, this.myListener.onBingNewsItem ) );
    }
  };
  
  this.onResultsReady = function(aJSON, aTextStatus, aJqHR)
  {
    if (this.myAbortFlag)
    {
      return;
    }

    if(aJSON && aJSON.d && aJSON.d.results && aJSON.d.results.length > 0)
    {
      this.parseResults(aJSON.d.results[0]);
    }
    else
    {
      console.log(aJqHR);
      this.myListener.onError("Woops! There was a problem getting tweets from Twitter: " + aTextStatus );
    }
  };

  this.onComplete = function( aJqHR, aTextStatus )
  {
    if ( aTextStatus == "success")
    {
      this.myListener.onSuccess();      
    }
    else
    {
      this.myListener.onError("Woops! There was a problem getting bing results: " + aTextStatus ); 
    }
  };
  
  this.onError = function(aJqXHR, aTextStatus, anErrorThrown)
  {
    console.log(anErrorThrown);
    this.myListener.onError("Woops! There was a problem getting bing results: " + aTextStatus );
  };

  
  this.callBingAjax = function( aUrl )
  {
    try
    {
      $.ajax(
      {
        url: aUrl,
        cache:false,
        dataType: "json",
        success: createDelegate(this, this.onResultsReady),
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
