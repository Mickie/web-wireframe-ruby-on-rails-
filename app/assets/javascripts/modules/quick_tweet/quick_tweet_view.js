var QuickTweetView = function( aControlsDivSelector )
{
  this.myControlsDivSelector = aControlsDivSelector;
  this.myController = new QuickTweetController();
  
  this.initializeButtons = function( aSportId )
  {
    this.myController.loadButtonData(aSportId, this);
  };
  
  this.onButtonDataLoaded = function()
  {
    this.myController.addQuickTweetButtons( $( this.myControlsDivSelector + " ul.dropdown-menu") );
    
    $( this.myControlsDivSelector + " p" ).each( createDelegate( this.myController, 
                                                                 this.myController.addQuickTweetClick ));
  };
  
  this.abort = function()
  {
    this.myController.abort();
  }
  
}
