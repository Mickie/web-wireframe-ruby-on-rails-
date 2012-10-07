var AmazonProducts = function( aListener )
{
  this.myCurrentTeamId;
  this.myListener = aListener;
  this.myAbortFlag = false;
  
  this.getSearchResultsForTeam = function( aTeamId )
  {
    this.myCurrentTeamId = aTeamId;
    
    this.callAmazonAjax( this.getSearchQuery(this.myCurrentTeamId) );
  };
  
  this.abort = function()
  {
    this.myAbortFlag = true;
  };
  
  this.getSearchQuery = function(anId)
  {
    return "/teams/" + anId + "/amazon_product_results.json";
  }
  
  this.parseResults = function (aResultsObject)
  {
    this.myListener.onAmazonResultsReady( aResultsObject );
  };
  
  this.onResultsReady = function(aJSON, aTextStatus, aJqHR)
  {
    if (this.myAbortFlag)
    {
      return;
    }

    if(aJSON)
    {
      this.parseResults(aJSON);
    }
    else
    {
      console.log(aJqHR);
      this.myListener.onError("Woops! There was a problem getting results from Amazon: " + aTextStatus );
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
      this.myListener.onError("Woops! There was a problem getting Amazon results: " + aTextStatus ); 
    }
  };
  
  this.onError = function(aJqXHR, aTextStatus, anErrorThrown)
  {
    console.log(anErrorThrown);
    this.myListener.onError("Woops! There was a problem getting Amazon results: " + aTextStatus );
  };

  
  this.callAmazonAjax = function( aUrl )
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
      this.myListener.onError("Woops! There was a problem getting Amazon results: " + anError );
    }
  };
  
}
