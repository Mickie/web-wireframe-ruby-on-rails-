
var TwitterController = function(aTwitterView)
{
  this.myTwitterView = aTwitterView;
  this.myButtonsLoadedCallback;
  this.myQuickTweets = {};
  this.myAbortFlag = false;
  this.myTwitterInviteDialog = new TwitterInviteDialog();
  
  
  this.loadButtonData = function (aSportId, aButtonsLoadedCallback)
  {
    this.myAbortFlag = false;
    this.myButtonsLoadedCallback = aButtonsLoadedCallback;
    if (this.myQuickTweets.happy)
    {
      this.myButtonsLoadedCallback();
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
    this.myButtonsLoadedCallback = null;
  }
  
  this.onQuickTweetsComplete = function(aResult)
  {
    if (this.myAbortFlag)
    {
      return;
    }
    this.myQuickTweets = aResult;
    this.myButtonsLoadedCallback();
  };
  
  this.addQuickTweetClick = function( i, anAnchorElement )
  {
    $( anAnchorElement ).click( createDelegate(this, this.onQuickTweetClick) );
  };
  
  this.addQuickTweetButtons = function( aParentUL )
  {
    aParentUL.render( this.myQuickTweets, this.getQuickTweetButtonsDirective() );
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
    var theTweetText = theArrayOfChoices[theRandomIndex] + " " + this.myTwitterView.myHashTags;
  
    this.myTwitterView.updatePostForm(false, theTweetText);
    
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
  
  this.onReplyTo = function( aTweetId, aUser)
  {
    this.myTwitterView.updatePostForm(true, aUser + " " + this.myTwitterView.myHashTags, aTweetId);
    $("body").animate({scrollTop:0}, 400);
  };
  
  this.onRetweet = function( aTweetId, aTweetText )
  {
    this.myTwitterView.updatePostForm(true, aTweetText, "", aTweetId);
    $("body").animate({scrollTop:0}, 400);
  };
  
  this.onInvite = function( aTweetId, aUser )
  {
    var theMessage = aUser + ", I've got a conversation going about this on my @FanzoFans fanzone, interested? " + this.myTwitterView.myHashTags;
    this.myTwitterInviteDialog.showDialog( theMessage, aTweetId );
  };
  
   
}
