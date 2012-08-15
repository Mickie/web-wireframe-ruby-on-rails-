$(function(){
  initializeTileHover();
});

function initializeTileHover()
{
  $('.fanzoneTile').hover(createDelegate(this, this.onTileHoverStart), createDelegate(this, this.onTileHoverEnd));
}

function onTileHoverStart(e)
{
  $(e.currentTarget).find(".fanzoneState").show();
}

function onTileHoverEnd(e)
{
  $(e.currentTarget).find(".fanzoneState").hide();
}
