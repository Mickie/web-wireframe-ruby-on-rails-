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
  if (confirm("Are you sure you want to call the foul?\n\nThis will go down on their permanent record...\n\n"))
  {
    submitVote(e);
  }
}
