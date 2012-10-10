var FanzoNavigator = function()
{
  this.myCurrentHash = window.location.hash;
  this.myCreateFanzoneDialog = new FanzoneDialog("#myCreateFanzoneModal", false);
  this.mySearchSubmitInProcessFlag = false;
  this.myLoadInProgress = false;
  
  this.initialize = function()
  {
    this.initializeNavigationWatchers();
    this.myCreateFanzoneDialog.initialize();
    EventManager.get().addObserver("onCreatePostComplete", this);
  };
  
  this.notifySearchComplete = function()
  {
    updateTimeStamps();
  };
  
  this.onCreatePostComplete = function()
  {
    this.updatePinterestButtons();
  }
  
  this.initializeNavigationWatchers = function()
  {
    $('#fanzone_search form').on('submit', createDelegate(this, this.onSearchSubmit) );
    $('#fanzone_search').on('railsAutocomplete.select', createDelegate(this, this.onSearchSelect) );
    $('#fanzone_search .icon-remove').on('click', createDelegate(this, this.onSearchClear) );
    $('#frameContent').on('submit', "#welcome .teamSearch form", createDelegate(this, this.onSearchSubmit) );
    $('#frameContent').on('railsAutocomplete.select', "#welcome .teamSearch", createDelegate(this, this.onSearchSelect) );
    $('#frameContent').on('click', "#welcome .teamSearch .icon-remove", createDelegate(this, this.onSearchClear) );
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
  
  this.updatePinterestButtons = function()
  {
    $('script[src*="assets.pinterest.com/js/pinit.js"]').remove();
    $.ajax({ url: 'http://assets.pinterest.com/js/pinit.js', dataType: 'script', cache:true});
  };
    
  this.onSearchSubmit = function(e)
  { 
    this.trackSearchResult(e.target);
  }
  
  this.onSearchSelect = function(e)
  {
    this.trackSearchResult(e.target.form);
    $.rails.handleRemote($(e.target.form));
  }
  
  this.trackSearchResult = function(aParent)
  {
    var theTeam = $(aParent).find("#team").val();
    var theTeamId = $(aParent).find("#team_id").val();
    trackEvent("Navigator", "search_submit", theTeam, theTeamId);    
  }
  
  this.onSearchClear = function(e)
  {
    $(e.target.parentElement).find("input#team").val("");
  }
        
}
