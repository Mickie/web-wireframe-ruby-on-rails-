var TilesView = function()
{
  this.myPullToRefreshScroller = null;

  this.initialize = function()
  {
    this.myPullToRefreshScroller = new PullToRefreshScroller("phoneTileContent", this);
    this.myPullToRefreshScroller.initialize();
  }
  
  this.onHidden = function()
  {
    this.myPullToRefreshScroller.cleanup();
  }

  this.onShown = function()
  {
    this.myPullToRefreshScroller.initialize();
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
    
    this.myPullToRefreshScroller.update();
  };
  
  this.onLoadError = function(anError)
  {
    console.log(anError);  
  };

  
}
