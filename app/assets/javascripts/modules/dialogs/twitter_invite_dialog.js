var TwitterInviteDialog = function()
{

  this.showDialog = function( aMessage, aReplyId )
  {
    $("#myTwitterInviteModal #sendTweetButton").on("click", createDelegate( this, this.onSendTweet ) );
    $("#myTwitterInviteModal #sendTweetButton").attr("reply_id", aReplyId);
    $("#myTwitterInviteModal #tweetText").val(aMessage);
    $("#myTwitterInviteModal").modal("show");
  };
  
  this.onSendTweet = function()
  {
    var theReplyId = $("#myTwitterInviteModal #sendTweetButton").attr("reply_id");
    var theTweetText = $("#myTwitterInviteModal #tweetText").val();
    var theBitly = $("#myTwitterInviteModal #tailgate_bitly").text();
    $.post( "/twitter_proxy/update_status", 
            { statusText : theTweetText + " " + theBitly, replyId : theReplyId }, 
            createDelegate(this, this.onTweetComplete), 
            "json" );
    trackEvent("TwitterInvite", "send_picked", theTweetText);    
  };
  
  this.onTweetComplete = function(aResponse)
  {
    $("body").animate({scrollTop:0}, 400);
    $("#twitterInviteSuccessAlert").slideDown(600);
    $("#myTwitterInviteModal #tweetText").val("");
    $("#myTwitterInviteModal #sendTweetButton").off("click");
    setTimeout(createDelegate(this, this.hideTweetSuccess), 5000);
  };
  
  this.hideTweetSuccess = function()
  {
    $("#twitterInviteSuccessAlert").slideUp(600);
  };
  
}
