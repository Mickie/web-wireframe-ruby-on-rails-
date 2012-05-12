
var TwitterController = function(aTwitterView)
{
  this.myTwitterView = aTwitterView;
  
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
  
  this.myTweetHash = 
  {
    happy : 
      [
        {
          name:"Monster Dunk!",
          tweets: 
            [
              "Did you see that dunk?!?  You could hear that thing in Brooklyn!",
              "Dude, he just stuffed that down with a two hand jam!",
              "Sweet!  Throw that bad boy down!"
            ]
        },
        {
          name: "Swoosh!",
          tweets:
            [
              "Nothing but net, baby!",
              "Swoosh! That was a thing of beauty!",
              "You gotta love a money shot like that!"
            ]
        },
        {
          name: "In your face!",
          tweets:
            [
              "You think you're gonna come in to our house? I  D O N ' T  T H I N K  S O !!!",
              "Get that outta here, this is MY paint!",
              "Booyah baby!"
            ]
        },
        {
          name: "Defense!",
          tweets:
            [
              "Shut it down!  They got N O T H I N G!",
              "Now that is defense, baby.  Bring the stop!",
              "That zone is as tight!"
            ]
        },
        {
          name: "Offense!",
          tweets:
            [
              "Shoot that!  You know you feeling it!",
              "Come on, let's move the ball around. Look for the open man!",
              "Bring the rain!"
            ]
        },
        {
          name: "So Pretty!",
          tweets:
            [
              "Nothing but N E T, baby!",
              "Did you see that move?!?!",
              "Damn, but that looked good!"
            ]
        }
        
      ],
    sad:
      [
        {
          name:"What Defense?",
          tweets: 
            [
              "You call that defense? You're supposed to keep the ball out of the basket, not help it in!",
              "My grandma can play better defense than this, in combat boots!",
              "Why don't you just sit down and WATCH the game, cuz you can't seem to PLAY it"
            ]
        },
        {
          name:"Foul!",
          tweets: 
            [
              "That is what you call a foul ref! Have you forgotten what that is?",
              "Damn, that had to hurt.  Call the foul ref!",
              "I'll show you a charge, with my semi!"
            ]
        },
        {
          name:"You kidding?",
          tweets: 
            [
              "You have got to be kidding me ref, are you just making this up as you go?",
              "The game is called basketball ref, perhaps you should study up a bit!",
              "Seriously?  You have got to be kidding me!  Did I really just see that, or did the world just go crazy?"
            ]
        },
        {
          name:"Ref's blind!",
          tweets: 
            [
              "Damn, that ref is blind as a bat",
              "Open your eyes ref, or do you have any?",
              "How can you not see that foul?"
            ]
        },
        {
          name:"What Offense?",
          tweets: 
            [
              "Put the rock in the hole! How hard is that?",
              "That boy can't hit the broadside of a barn! That brick must have weighed a ton, it almost put a hole in the floor!",
              "Shoot the ball, don't snuggle it!"
            ]
        },
        {
          name:"Ouch!",
          tweets: 
            [
              "That had to hurt!",
              "I gotta close my eyes, tell me when the real team shows up.",
              "Ouch, hope that dude is ok.  I think he just lost his shorts!"
            ]
        },
      ]
  }
  
}
