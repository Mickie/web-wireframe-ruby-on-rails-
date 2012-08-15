$(function(){
  initializeTileHover();
});

function initializeTileHover()
{
  $('.fanzoneTile').live('mouseenter', onTileHoverStart).live('mouseleave', onTileHoverEnd);
}

function onTileHoverStart(e)
{
  $(e.currentTarget).find(".fanzoneState").show();
}

function onTileHoverEnd(e)
{
  $(e.currentTarget).find(".fanzoneState").hide();
}
