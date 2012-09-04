
var TwitterController = function(aTwitterView)
{
  this.myTwitterView = aTwitterView;
  this.myTwitterInviteDialog = new TwitterInviteDialog();
  
  this.onReplyTo = function(e)
  {
    var theTweetId = $(e.target).attr("data-tweet-id");
    var theUser = $(e.target).attr("data-user");

    this.myTwitterView.updatePostForm(true, "@" + theUser + " " + this.myTwitterView.myHashTags, theTweetId);
    $("body").animate({scrollTop:0}, 400);
    trackEvent("Twitter", "reply_click");    
  };
  
  this.onRetweet = function(e)
  {
    var theTweetId = $(e.target).attr("data-tweet-id");
    var theUser = $(e.target).attr("data-user");
    var theTweetText = $(e.target).attr("data-tweet-text");

    this.myTwitterView.updatePostForm(true, "RT @" + theUser + ": " + theTweetText, "", theTweetId);
    $("body").animate({scrollTop:0}, 400);
    trackEvent("Twitter", "retweet_click");    
  };
  
  this.onInvite = function(e)
  {
    var theTweetId = $(e.target).attr("data-tweet-id");
    var theUser = $(e.target).attr("data-user");

    var theMessage = "@" + theUser + ", I've got a conversation going about this on my @FanzoFans fanzone, interested? " + this.myTwitterView.myHashTags;
    this.myTwitterInviteDialog.showDialog( theMessage, theTweetId );
    trackEvent("Twitter", "invite_click");    
  };
  
   
}
