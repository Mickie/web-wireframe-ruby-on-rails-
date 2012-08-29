var QuickTweetView = function( aControlsDivSelector, aListener )
{
  this.myControlsDivSelector = aControlsDivSelector;
  this.myListener = aListener;
  this.myController = new QuickTweetController(this);
  this.myHashTags = {};
  
  this.initializeButtons = function( aSportId, aHashTags )
  {
    this.myHashTags = aHashTags;
    this.myController.loadButtonData( aSportId );
  };
  
  this.onButtonDataLoaded = function()
  {
    this.myController.addQuickTweetButtons( $( this.myControlsDivSelector + " ul.dropdown-menu") );
    
    $( this.myControlsDivSelector + " p" ).each( createDelegate( this.myController, 
                                                                 this.myController.addQuickTweetClick ));
  };
  
  this.updatePostForm = function( aForceTwitterFlag, aDefaultText )
  {
    this.myListener.updatePostForm( aForceTwitterFlag, aDefaultText + " " + this.myHashTags);
  }
  
  this.abort = function()
  {
    this.myController.abort();
  }
  
}

var mySingletonQuickTweetView;
QuickTweetView.create = function(aControlsDivSelector, aListener)
{
  if (mySingletonQuickTweetView)
  {
    mySingletonQuickTweetView.abort();
    return mySingletonQuickTweetView;
  }
  
  mySingletonQuickTweetView = new QuickTweetView(aControlsDivSelector, aListener);
  return mySingletonQuickTweetView;
}
