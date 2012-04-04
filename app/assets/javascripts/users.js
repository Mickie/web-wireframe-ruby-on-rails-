
function checkInToGame( e )
{
  window.location = "game/watch?game=" + escape( e.target.value );
}