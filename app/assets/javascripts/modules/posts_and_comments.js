$(function()
{
  initializePostAndComments();
});

function initializePostAndComments()
{
  $("#posts #new_comment").live('ajax:before',checkStatus);
  $(".vote_up i:not(.disabled)").live('click', submitVote);
  $(".vote_down i:not(.disabled)").live('click', submitDownVote);
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
}
