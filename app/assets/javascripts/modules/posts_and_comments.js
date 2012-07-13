$(function()
{
  initializePostAndComments();
});

function initializePostAndComments()
{
  $("#posts #comment_content").live('keyup',submitComment);
  $(".post_votes .vote_up i").live('click', submitUpVote);
  $(".post_votes .vote_down i").live('click', submitDownVote);
}

function submitComment(e)
{
  if (e.keyCode === 13 && !e.ctrlKey) 
  {
    $(e.target.form).submit();
    return false;
  }
}

function submitUpVote(e)
{
  $(e.target.parentElement).submit();
}

function submitDownVote(e)
{
  if (confirm("Are you sure you want to call the foul?\n\nThis will do down on their permanent record...\n\n"))
  {
    $(e.target.parentElement).submit();
  }
}
