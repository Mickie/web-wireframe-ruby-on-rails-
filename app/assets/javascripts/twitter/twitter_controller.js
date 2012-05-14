
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
  
  this.addTweetClick = function( i, anAnchorElement )
  {
      anAnchorElement.href = "#";
      $( anAnchorElement ).click( createDelegate(this, this.onTweetClick) );
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
  
  this.onTweetClick = function( e )
  {
    var theKey = e.target.attributes[1].nodeValue;
    var theArrayOfChoices = this.getQuickTweetChoices(theKey);
    var theRandomIndex = Math.floor( Math.random()
                                     * theArrayOfChoices.length );
    var theTweetText = theArrayOfChoices[theRandomIndex] + " " + this.myTwitterView.myHashTags;
  
    this.myTwitterView.showTweetDialog(theTweetText);
    
    $("#sendTweetButton").unbind("click");
    $("#sendTweetButton").click(createDelegate(this, this.onSendTweetFromModal));
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
  
  this.onSendTweetFromModal = function( e )
  {
    var theTweetText = $("#tweetText").val();
    this.sendTweet(theTweetText);
    $("#myTweetModal").modal("hide"); 
  };
  
  this.sendTweet = function(aTweetText)
  {
    $.post( "/twitter_proxy/update_status", 
            {statusText : aTweetText }, 
            createDelegate(this.myTwitterView, this.myTwitterView.onTweetComplete), 
            "json" );  
  };
  
  this.onReplyTo = function( aTweetId, aUser)
  {
    this.myTwitterView.showTweetDialog(aUser + " " + this.myTwitterView.myHashTags);
    $("#sendTweetButton").click(createDelegate(this, this.onSendReply)).attr("reply_id", aTweetId);    
  };
  
  this.onSendReply = function( e )
  {
    var theReplyId = $("#sendTweetButton").attr("reply_id");
    var theTweetText = $("#tweetText").val();
    $.post( "/twitter_proxy/update_status", 
            {statusText : theTweetText, replyId : theReplyId }, 
            createDelegate(this.myTwitterView, this.myTwitterView.onTweetComplete), 
            "json" );  
  };
    
  this.onRetweet = function( aTweetId )
  {
    $.post( "/twitter_proxy/retweet", 
            { tweetId : aTweetId }, 
            createDelegate(this.myTwitterView, this.myTwitterView.onRetweetComplete), 
            "json"); 
  };
  
  this.onFavorite = function( aTweetId )
  {
    $.post( "/twitter_proxy/favorite", 
            { favoriteId : aTweetId }, 
            createDelegate(this.myTwitterView, this.myTwitterView.onFavoriteComplete), 
            "json"); 
  };
  
   
}
