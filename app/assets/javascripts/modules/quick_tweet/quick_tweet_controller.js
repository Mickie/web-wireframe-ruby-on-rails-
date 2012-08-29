var QuickTweetController = function( aListener )
{
  this.myListener = aListener;
  this.myQuickTweets = {};
  this.myAbortFlag = false;
  
  this.loadButtonData = function (aSportId)
  {
    this.myAbortFlag = false;
    if (this.myQuickTweets.happy)
    {
      this.myListener.onButtonDataLoaded();
    }
    else
    {
      $.getJSON("/quick_tweets.json?sport_id=" + aSportId, 
                createDelegate(this, this.onQuickTweetsComplete));
    }
  };
  
  this.abort = function()
  {
    this.myAbortFlag = true;
    this.myListener = null;
  }
  
  this.onQuickTweetsComplete = function(aResult)
  {
    if (this.myAbortFlag)
    {
      return;
    }
    this.myQuickTweets = aResult;
    this.myListener.onButtonDataLoaded();
  };
  
  this.addQuickTweetClick = function( i, anAnchorElement )
  {
    $( anAnchorElement ).click( createDelegate(this, this.onQuickTweetClick) );
  };
  
  this.addQuickTweetButtons = function( aParentUL )
  {
    try
    {
      aParentUL.render( this.myQuickTweets, this.getQuickTweetButtonsDirective() );
    }
    catch(e)
    {
      console.log("error adding quick tweet buttons: " + e);
    }
  };
  
  this.getQuickTweetButtonsDirective = function()
  {
    return {
      'div.happy li': {
        'tweetGroup <- happy':{
          'p' : 'tweetGroup.name',
          'p@data' : 'tweetGroup.name' 
        }
      },
      'div.sad li': {
        'tweetGroup <- sad':{
          'p' : 'tweetGroup.name',
          'p@data' : 'tweetGroup.name' 
        }
      }
    }
  };
  
  this.onQuickTweetClick = function( e )
  {
    var theKey = e.target.attributes[0].nodeValue;
    var theArrayOfChoices = this.getQuickTweetChoices(theKey);
    var theRandomIndex = Math.floor( Math.random()
                                     * theArrayOfChoices.length );
  
    this.myListener.updatePostForm(false, theArrayOfChoices[theRandomIndex]);
    
    trackEvent("Twitter", "quick_tweet_click", theKey);    
  };
  
  this.getQuickTweetChoices = function( aKey )
  {
    var theChoice = this.findChoices(aKey, this.myQuickTweets.happy);
    if( !theChoice )
    {
      theChoice = this.findChoices(aKey, this.myQuickTweets.sad);
    }
    return theChoice;
  };
  
  this.findChoices = function(aKey, anObjectArray)
  {
    for (var i=0; i < anObjectArray.length; i++) 
    {
      if ( aKey == anObjectArray[i].name )
      {
        return anObjectArray[i].tweets;
      }
    }
    return null;    
  };
}
