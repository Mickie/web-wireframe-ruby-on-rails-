
var TwitterController = function(aTwitterView)
{
  this.myTwitterView = aTwitterView;
  this.myTwitterInviteDialog = new TwitterInviteDialog();
  
  this.onReplyTo = function( aTweetId, aUser)
  {
    this.myTwitterView.updatePostForm(true, aUser + " " + this.myTwitterView.myHashTags, aTweetId);
    $("body").animate({scrollTop:0}, 400);
    trackEvent("Twitter", "reply_click");    
  };
  
  this.onRetweet = function( aTweetId, aTweetText, aUser )
  {
    this.myTwitterView.updatePostForm(true, "RT " + aUser + ": " + aTweetText, "", aTweetId);
    $("body").animate({scrollTop:0}, 400);
    trackEvent("Twitter", "retweet_click");    
  };
  
  this.onInvite = function( aTweetId, aUser )
  {
    var theMessage = aUser + ", I've got a conversation going about this on my @FanzoFans fanzone, interested? " + this.myTwitterView.myHashTags;
    this.myTwitterInviteDialog.showDialog( theMessage, aTweetId );
    trackEvent("Twitter", "invite_click");    
  };
  
   
}
