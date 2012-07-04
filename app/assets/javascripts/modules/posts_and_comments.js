$(function()
{
  initializePostAndComments();
});

function initializePostAndComments()
{
  $("#posts #comment_content").live('keyup',submitComment);
}

function submitComment(e)
{
  if (e.keyCode === 13 && !e.ctrlKey) 
  {
    $(e.target.form).submit();
    return false;
  }
}

