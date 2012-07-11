function handleFollowClick(anEvent)
{
  $.rails.handleRemote($(anEvent.target.form));
  anEvent.stopPropagation();
  return false;
}
