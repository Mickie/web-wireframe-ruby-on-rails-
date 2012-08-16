function handleFollowClick(anEvent)
{
  $.rails.handleRemote($(anEvent.target.form));
  anEvent.stopPropagation();
  
  trackEvent("FollowButton", "follow_clicked", $(anEvent.target).attr("id"));    
  
  return false;
}
