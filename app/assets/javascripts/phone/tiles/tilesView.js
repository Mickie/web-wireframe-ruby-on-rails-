var TilesView = function()
{
  this.myTileScroller = null;

  this.initialize = function()
  {
    this.setupTileScroller();
  }
  
  this.onHidden = function()
  {
    this.cleanupTileScroller();
  }

  this.onShown = function()
  {
    this.setupTileScroller();
  }
  
  this.loadAllFanzones = function()
  {
    this.loadTilesIntoFrameContent("/tailgates?noLayout=true");
  }

  this.loadMyFanzones = function()
  {
    this.loadTilesIntoFrameContent("/tailgates?filter=user&noLayout=true")
  }

  this.loadTilesIntoFrameContent = function( aPath )
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    $.ajax({
             url: aPath + "&authenticity_token=" + theToken,
             cache:false,
             dataType: "html",
             success: createDelegate(this, this.onTileLoadComplete ),
             error: createDelegate(this, this.onLoadError )
           });
  };

  this.onTileLoadComplete = function(aResult)
  {
    $("#frameContent").html(aResult);
    updateTimestamps();
    
    if (this.myTileScroller)
    {
      this.myTileScroller.refresh();
    }
  };
  
  this.onLoadError = function(anError)
  {
    console.log(anError);  
  };

  this.setupTileScroller = function()
  {
    this.myTileScroller = new iScroll("phoneTileContent");
  }
  
  this.cleanupTileScroller = function()
  {
    if (this.myTileScroller)
    {
      this.myTileScroller.destroy()
      this.myTileScroller = null;
    }
  }
  
}
