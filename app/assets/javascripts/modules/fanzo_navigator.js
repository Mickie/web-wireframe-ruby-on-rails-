var FanzoNavigator = function()
{
  this.myCurrentHash = window.location.hash;
  this.myCreateFanzoneDialog = new FanzoneDialog("#myCreateFanzoneModal", false);
  this.mySearchSubmitInProcessFlag = false;
  
  this.initialize = function()
  {
    this.updateFrameFromHash();
    this.initializeNavigationWatchers();
    this.myCreateFanzoneDialog.initialize();
  };
  
  this.notifySearchComplete = function()
  {
    this.mySearchSubmitInProcessFlag = false;
  };
  
  this.updateFrameFromHash = function()
  {
    var theHash = this.getNavigationHash();
    
    if( theHash.length > 0 )
    {
      this.loadFrameFromHash(theHash);
    }
    else if ( this.myCurrentHash.length > 0 )
    {
      this.navToAllFanzones();
    }
  };

  this.initializeNavigationWatchers = function()
  {
    window.onhashchange = createDelegate(this, this.updateFrameFromHash);
    $('#myLoginModal').on('shown', createDelegate(this, this.saveLocation) );
    $('#myLoginModal').on('hidden', createDelegate(this, this.clearLocation) );  
    $('#myConnectTwitterModal').on('shown', createDelegate(this, this.saveLocation) );
    $('#myConnectTwitterModal').on('hidden', createDelegate(this, this.clearLocation) );
    $('#fanzone_search form').on('submit', createDelegate(this, this.onSearchSubmit) );
    $('#fanzone_search').on('railsAutocomplete.select', createDelegate(this, this.onSearchSelect) );
  };
  
  this.loadData = function(aPath, aNewActiveSelector)
  {
    if (window.location.hash != aNewActiveSelector)
    {
      window.location.hash = aNewActiveSelector;
      return;
    }
    
    InfiniteScroller.get().stop();

    this.addActiveToCurrentNavItem(aNewActiveSelector);
    this.displayLoading();
    this.getDataFromServer( aPath );    
  };
  
  
  this.loadFrameFromHash = function( aHash )
  {
    this.myCurrentHash = aHash;
    var theElement = [];

    if ( this.isFacebookCallbackHash( aHash ) )
    {
      window.location.hash = "";
    }
    else if ( this.isSearchHash( aHash ) )
    {
      if ( !this.mySearchSubmitInProcessFlag )
      {
        this.submitLastSavedSearch();
      }
    }
    else if ( (theElement = this.getLeftNavElement( aHash ) ) && theElement.length > 0 )
    {
      theElement.click();
      theElement.addClass('active');
    }
    else
    {
      this.parseHashAndLoadFrame( aHash );
    }
  };
  
  this.navToAllFanzones = function()
  {
    $('#allFanzones a').click();
    $('#allFanzones').addClass('active');
  };
  
  this.getDataFromServer = function( aPath )
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    $.ajax({
             url: aPath + "&authenticity_token=" + theToken,
             cache:false,
             dataType: "html",
             success: createDelegate(this, this.onLoadDataComplete ),
             error: createDelegate(this, this.onLoadError )
           });
  }
  
  this.parseHashAndLoadFrame = function( aHash )
  {
    var theTailgateId = this.getIdFromHash(aHash);
    if (theTailgateId)
    {
      this.loadData("/tailgates/" + theTailgateId + "?noLayout=true", aHash);
    }
    else
    {
      this.navToAllFanzones();
    }
  };
  
  this.submitLastSavedSearch = function()
  {
    var theCurrentSearchVal = getCookie("myCurrentSearchVal");
    $("#fanzone_search #team_id").val(theCurrentSearchVal);
    $('#fanzone_search form').submit();
  };
  
  this.getNavigationHash = function()
  {
    var theHash = "";
    var theLocationCookie = getCookie("myCurrentLocationHash");
    if (theLocationCookie && theLocationCookie.length > 0)
    {
      theHash = theLocationCookie;
      setCookie("myCurrentLocationHash", "");
    }
    else
    {
      theHash = window.location.hash;
    }
    
    return theHash;
  };
  
  this.onLoadDataComplete = function(aResult)
  {
    $("#frameContent").html(aResult);
    window.scrollTo( 0, 1 );
    
    if ($(".active").attr("id") == "allFanzones")
    {
      InfiniteScroller.get().handleScrollingForResource("/tailgates");
    }
    updateTimestamps();
    window.fbAsyncInit();
  };

  this.onLoadError = function(anError)
  {
    console.log(anError);  
  };

  this.onSearchSubmit = function()
  {
    this.mySearchSubmitInProcessFlag = true;
    setCookie( "myCurrentSearchVal", $("#fanzone_search #team_id").val(), 5);
    InfiniteScroller.get().stop();
    window.location.hash = "#search";
  }
  
  this.onSearchSelect = function()
  {
    $('#fanzone_search form').submit();
  };
  
  this.getIdFromHash = function( aHash )
  {
    var thePieces = aHash.split("_");
    if (thePieces[0] == "#nav" || thePieces[0] == "#tailgate")
    {
      return thePieces[thePieces.length-1];
    }
    
    return null;
  };

  this.addActiveToCurrentNavItem = function( aNewActiveSelector )
  {
    $('.active').removeClass('active');
    $(aNewActiveSelector).addClass('active'); 
  };
  
  this.saveLocation = function()
  {
    setCookie("myCurrentLocationHash", window.location.hash);
  };
  
  this.clearLocation = function() 
  {
    setCookie("myCurrentLocationHash", "");
  };  
    
  this.isFacebookCallbackHash = function( aHash )
  {
    return ( aHash == "#_=_" );
  };
  
  this.isSearchHash = function( aHash )
  {
    return ( aHash == "#search" );
  };
  
  this.getLeftNavElement = function( aHash )
  {
    return $("#fanzo_navigation " + aHash + " a");
  };
  
  this.displayLoading = function()
  {
    $("#frameContent").html("<div style='height:700px;'><h1 style='text-align:center'><img src='/assets/loading.gif' style='margin:20px'/>Loading</h1></div>");
    $("body").scrollTop(0);
  };
}
