$(function()
{
  initializePostAndComments();
});

function initializePostAndComments()
{
  $("#posts #comment_content").live('keyup',submitComment);
  $(".post_votes .vote_up i").live('click', submitVote);
  $(".post_votes .vote_down i").live('click', submitDownVote);
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
  if (confirm("Are you sure you want to call the foul?\n\nThis will do down on their permanent record...\n\n"))
  {
    submitVote(e);
  }
}
