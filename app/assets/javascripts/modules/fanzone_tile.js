$(function(){
  initializeTileHover();
  stopAnchorFromNavigation();
});

function initializeTileHover()
{
  $('#frameContent').on('mouseenter', ".fanzoneTile", onTileHoverStart).on('mouseleave', ".fanzoneTile", onTileHoverEnd);
}

function onTileHoverStart(e)
{
  $(e.currentTarget).find(".fanzoneState").show();
}

function onTileHoverEnd(e)
{
  $(e.currentTarget).find(".fanzoneState").hide();
}

function stopAnchorFromNavigation()
{
  $('.fanzoneTile').on('click', 'a', onAnchorClick);
}

function onAnchorClick(e)
{
  e.stopPropagation();
  e.preventDefault();
  return false;
}
