$(function()
{
  initializePostAndComments();
});

function initializePostAndComments()
{
  $("#frameContent").on('ajax:before', ".new_comment", checkStatus);
  $("#frameContent").on('click', ".vote_up i:not(.disabled)", submitUpVote);
  $("#frameContent").on('click', ".vote_down i:not(.disabled)", submitDownVote);
}

function checkStatus(e)
{
  if (!myTwitterView.isLoggedIn())
  {
    myTwitterView.showFacebookModal();
    return false;
  }
  
  return true;
}

function submitVote(e)
{
  if (myTwitterView.isLoggedIn())
  {
    $(e.target.parentElement).submit();
  }
  else
  {
    myTwitterView.showFacebookModal();
  }
}

function submitUpVote(e)
{
  submitVote(e);
}

function submitDownVote(e)
{
  if ($(e.target).hasClass('mine'))
  {
    return;
  }
  
  if (confirm("Mark this as spam or offensive?\n\nIt will be removed from your stream.\n\n"))
  {
    submitVote(e);
  }
  else
  {
    trackEvent("PostAndComments", "cancel_down_vote", $(e.target.parentElement).attr("id"));    
  }
  
}
