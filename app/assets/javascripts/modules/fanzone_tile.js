$(function(){
  initializeTileHover();
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
