$(function()
{
  initializePostAndComments();
});

function initializePostAndComments()
{
  $("#posts #comment_content").live('keyup',submitComment);
  $(".vote_up i:not(.disabled)").live('click', submitVote);
  $(".vote_down i:not(.disabled)").live('click', submitDownVote);
}

function submitComment(e)
{
  if (e.keyCode === 13 && !e.ctrlKey) 
  {
    if (myTwitterView.isLoggedIn())
    {
      $(e.target.form).submit();
    }
    else
    {
      myTwitterView.showFacebookModal();
    }
    return false;
  }
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
  if (confirm("Mark this as spam or offensive?\n\nIt will be removed from your stream.\n\n"))
  {
    submitVote(e);
  }
}
