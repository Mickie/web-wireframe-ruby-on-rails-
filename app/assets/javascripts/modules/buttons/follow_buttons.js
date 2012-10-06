function handleFollowClick(e)
{
  var theParent = $(e.target.form).parent();
  $(e.target.form).on("ajax:complete", function(anXHR, aStatus)
  {
    theParent.click();
  });
  
  $.rails.handleRemote($(e.target.form));
  e.stopPropagation();
  
  trackEvent("FollowButton", "follow_clicked", $(e.target).attr("id"));    
  
  return false;
}
