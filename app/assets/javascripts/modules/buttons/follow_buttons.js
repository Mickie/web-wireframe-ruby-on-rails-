function handleFollowClick(e)
{
  $.rails.handleRemote($(e.target.form));
  
  trackEvent("FollowButton", "follow_clicked", $(e.target).attr("id"));    
  
  return false;
}
