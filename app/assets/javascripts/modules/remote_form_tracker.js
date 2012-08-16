$(function()
{
  $("#page_content").on("ajax:before", "form[data-remote]", trackRemoteFormSubmit);
  $("#page_content").on("click", "a[data-remote]", trackRemoteLinkClick);
});

function trackRemoteFormSubmit(e)
{
  trackEvent("RemoteForm", $(e.currentTarget).attr("action"), "submit");    
}

function trackRemoteLinkClick(e)
{
  trackEvent("RemoteForm", $(e.currentTarget).attr("href"), "click");    
}
