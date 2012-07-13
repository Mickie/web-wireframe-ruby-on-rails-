$(function()
{
  initializePostAndComments();
});

function initializePostAndComments()
{
  $("#posts #comment_content").live('keyup',submitComment);
  $(".post_votes .vote_up i").live('click', submitVote);
  $(".post_votes .vote_down i").live('click', submitVote);
}

function submitComment(e)
{
  if (e.keyCode === 13 && !e.ctrlKey) 
  {
    $(e.target.form).submit();
    return false;
  }
}

function submitVote(e)
{
  $(e.target.parentElement).submit();
}
