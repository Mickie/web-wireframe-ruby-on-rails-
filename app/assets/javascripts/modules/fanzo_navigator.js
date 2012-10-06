var FanzoNavigator = function()
{
  this.myCurrentHash = window.location.hash;
  this.myCreateFanzoneDialog = new FanzoneDialog("#myCreateFanzoneModal", false);
  this.mySearchSubmitInProcessFlag = false;
  this.myLoadInProgress = false;
  
  this.initialize = function()
  {
    this.updateFrameFromHash();
    this.initializeNavigationWatchers();
    this.myCreateFanzoneDialog.initialize();
    EventManager.get().addObserver("onCreatePostComplete", this);
  };
  
  this.isLoadInProgress = function()
  {
    return this.myLoadInProgress || this.mySearchSubmitInProcessFlag;
  }
  
  this.notifySearchComplete = function()
  {
    this.mySearchSubmitInProcessFlag = false;
  };
  
  this.onCreatePostComplete = function()
  {
    this.updatePinterestButtons();
  }
  
  this.updateFrameFromHash = function()
  {
    var theHash = this.getNavigationHash();
    
    if( theHash.length > 0 )
    {
      this.loadFrameFromHash(theHash);
    }
    else if ( this.myCurrentHash.length > 0 && !this.isFacebookCallbackHash( this.myCurrentHash ))
    {
      window.location = window.location.protocol + "//" + window.location.host + window.location.pathname;
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
    $('#fanzone_search .icon-remove').on('click', createDelegate(this, this.onSearchClear) );
    $('#welcome .teamSearch form').on('submit', createDelegate(this, this.onSearchSubmit) );
    $('#welcome .teamSearch').on('railsAutocomplete.select', createDelegate(this, this.onSearchSelect) );
    $('#welcome .teamSearch .icon-remove').on('click', createDelegate(this, this.onSearchClear) );
    $('#account_content').hover(createDelegate(this, this.onAccountHoverStart), createDelegate(this, this.onAccountHoverEnd));
  };
  
  this.onAccountHoverStart = function(e)
  {
    $('#account_dropdown .users_name').dropdown('open');
  };
  
  this.onAccountHoverEnd = function(e)
  {
    $('#account_dropdown .users_name').dropdown('close');
  };

  this.loadData = function(aPath, aNewActiveSelector)
  {
    if (window.location.hash != aNewActiveSelector)
    {
      window.location.hash = aNewActiveSelector;
      return;
    }
    
    this.myLoadInProgress = true;
    
    InfiniteScroller.get().stop();

    if (typeof myCurrentMediaSlider !== undefined && myCurrentMediaSlider)
    {
      myCurrentMediaSlider.reset();
    }

    this.addActiveToCurrentNavItem(aNewActiveSelector);
    this.displayLoading();
    
    this.getDataFromServer( aPath );

    trackEvent("Navigator", "loadData", aNewActiveSelector);
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
    var thePath;
    if (aPath.indexOf('?') != -1)
    {
      thePath = aPath + "&noLayout=true&authenticity_token=" + theToken;
    }
    else
    {
      thePath = aPath + "?noLayout=true&authenticity_token=" + theToken;
    }
    
    $.ajax({
             url: thePath,
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
  
  this.updatePinterestButtons = function()
  {
    $('script[src*="assets.pinterest.com/js/pinit.js"]').remove();
    $.ajax({ url: 'http://assets.pinterest.com/js/pinit.js', dataType: 'script', cache:true});
  };
  
  this.updateSocialButtons = function()
  {
    if (typeof FB !== 'undefined' && FB.XFBML)
    {
      FB.XFBML.parse();
    }
    if (typeof twttr !== 'undefined' && twttr.widgets)
    {
      twttr.widgets.load();
    }
    if (typeof gapi !== 'undefined' && gapi.plusone)
    {
      gapi.plusone.go();
    }
    this.updatePinterestButtons();
  };
  
  this.onLoadDataComplete = function(aResult)
  {
    this.myLoadInProgress = false;
    
    $("#frameContent").html(aResult);
    window.scrollTo( 0, 1 );
    
    if ($(".active").attr("id") == "allFanzones")
    {
      InfiniteScroller.get().handleScrollingForResource("/tailgates");
    }
    
    this.updateSocialButtons();
    updateTimestamps();
  };

  this.onLoadError = function(anError)
  {
    this.myLoadInProgress = false;
    console.log(anError);  
  };

  this.onSearchSubmit = function()
  {
    this.mySearchSubmitInProcessFlag = true;
    var theTeamId = $("#fanzone_search #team_id").val();
    setCookie( "myCurrentSearchVal", theTeamId, 5);
    InfiniteScroller.get().stop();
    window.location.hash = "#search";

    trackEvent("Navigator", "search_submit", $("#fanzone_search #team").val(), theTeamId);    
  }
  
  this.onSearchSelect = function()
  {
    $('#fanzone_search form').submit();
  };
  
  this.onSearchClear = function()
  {
    $("#fanzone_search input#team").val("");
  }
  
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
