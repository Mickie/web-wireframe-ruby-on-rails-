var TilesView = function()
{
  this.myPullToRefreshScroller = null;
  this.myCurrentPage = 1;

  this.initialize = function()
  {
    this.myPullToRefreshScroller = new PullToRefreshScroller("phoneTileContent", "tilesPullUp", "tilesPullDown", this);
    $('#phoneTeamSearch').on('railsAutocomplete.select', createDelegate(this, this.onSearchSelect) );

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
  
  this.onSearchComplete = function()
  {
    this.myPullToRefreshScroller.update();
    updateTimestamps();
  }
  
  this.onSearchSelect = function(e)
  {
    $('#phoneTeamSearch form').submit();
  }
  
  this.loadAllFanzones = function()
  {
    this.myBaseUrl = "/tailgates?noLayout=true";
    this.loadFirstPage();
  }

  this.loadMyFanzones = function()
  {
    this.myBaseUrl = "/tailgates?noLayout=true&filter=user";
    this.loadFirstPage();
  }

  this.loadFirstPage = function()
  {
    this.myCurrentPage = 1;
    this.displayLoading();
    this.loadTilesIntoFrameContent(this.getUrlForCurrentPage());
  }
  
  this.clearSearch = function()
  {
    $('#phoneTeamSearch #team').val("");
  }
  
  this.displayLoading = function()
  {
    $("#frameContent").hide();
    $("#frameLoading").show();
    this.myPullToRefreshScroller.scrollToTop();
  };
  
  
  this.getUrlForCurrentPage = function()
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    return this.myBaseUrl + "&authenticity_token=" + theToken + "&page=" + this.myCurrentPage;
  }

  this.loadTilesIntoFrameContent = function( aPath )
  {
    $.ajax({
             url: aPath,
             cache:false,
             dataType: "html",
             success: createDelegate(this, this.onTileLoadComplete ),
             error: createDelegate(this, this.onLoadError )
           });
  };
  
  this.loadNextPage = function()
  {
    this.myCurrentPage+=1;
    $.ajax({
      url: this.getUrlForCurrentPage(),
      type: 'get',
      dataType: 'script',
      complete: createDelegate(this, this.onLoadNextPageComplete)
    });
    trackEvent("InfiniteScroller", "loading_new_page", this.myResourceUrl, this.myCurrentPage);    
  }

  this.onTileLoadComplete = function(aResult)
  {
    $("#frameLoading").hide();
    $("#frameContent").html(aResult).show();
    updateTimestamps();
    
    this.myPullToRefreshScroller.update();
  };
  
  this.onLoadError = function(anError)
  {
    console.log(anError);  
  };
  
  this.onLoadNextPageComplete = function()
  {
    this.myPullToRefreshScroller.update();
  }

  this.pullDownAction = function()
  {
    this.loadFirstPage();
    this.clearSearch();
  }

  this.pullUpAction = function()
  {
    this.loadNextPage(); 
  }
}
