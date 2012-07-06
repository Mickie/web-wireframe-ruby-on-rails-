
var TwitterController = function(aTwitterView)
{
  this.myTwitterView = aTwitterView;
  this.myButtonsLoadedCallback;
  this.myTweetHash = {};
  
  
  this.loadButtonData = function (aSportId, aButtonsLoadedCallback)
  {
    this.myButtonsLoadedCallback = aButtonsLoadedCallback;
    $.getJSON("/quick_tweets.json?sport_id=" + aSportId, 
              createDelegate(this, this.onQuickTweetsComplete));
  };
  
  this.onQuickTweetsComplete = function(aResult)
  {
    this.myTweetHash = aResult;
    this.myButtonsLoadedCallback();
  };
  
  this.addQuickTweetClick = function( i, anAnchorElement )
  {
      anAnchorElement.href = "#";
      $( anAnchorElement ).click( createDelegate(this, this.onQuickTweetClick) );
  };
  
  this.addQuickTweetButtons = function( aParentUL )
  {
    aParentUL.render( this.myTweetHash, this.getQuickTweetButtonsDirective() );
  };
  
  this.getQuickTweetButtonsDirective = function()
  {
    return {
      'div.happy li': {
        'tweetGroup <- happy':{
          'a' : 'tweetGroup.name',
          'a@data' : 'tweetGroup.name' 
        }
      },
      'div.sad li': {
        'tweetGroup <- sad':{
          'a' : 'tweetGroup.name',
          'a@data' : 'tweetGroup.name' 
        }
      }
    }
  };
  
  this.onQuickTweetClick = function( e )
  {
    var theKey = e.target.attributes[1].nodeValue;
    var theArrayOfChoices = this.getQuickTweetChoices(theKey);
    var theRandomIndex = Math.floor( Math.random()
                                     * theArrayOfChoices.length );
    var theTweetText = theArrayOfChoices[theRandomIndex] + " " + this.myTwitterView.myHashTags;
  
    this.myTwitterView.updatePostForm(theTweetText);
    
  };
  
  this.getQuickTweetChoices = function( aKey )
  {
    var theChoice = this.findChoices(aKey, this.myTweetHash.happy);
    if( !theChoice )
    {
      theChoice = this.findChoices(aKey, this.myTweetHash.sad);
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
    this.myTwitterView.updatePostForm(aUser + " " + this.myTwitterView.myHashTags, aTweetId);
  };
  
  this.onRetweet = function( aTweetId, aTweetText )
  {
    this.myTwitterView.updatePostForm(aTweetText, "", aTweetId);
  };
  
  this.onFavorite = function( aTweetId )
  {
    console.log("TODO: need to handle");
    $.post( "/twitter_proxy/favorite", 
            { favoriteId : aTweetId }, 
            createDelegate(this.myTwitterView, this.myTwitterView.onFavoriteComplete), 
            "json"); 
  };
  
   
}
