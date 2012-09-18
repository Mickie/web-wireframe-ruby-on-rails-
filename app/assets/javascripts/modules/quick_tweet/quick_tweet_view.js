var QuickTweetView = function( aContainerSelector, aListener )
{
  this.myContainerSelector = aContainerSelector;
  this.myListener = aListener;
  this.myController = new QuickTweetController(this);
  this.myHashTags = {};
  
  this.initialize = function( aSportId, aHashTags )
  {
    this.myHashTags = aHashTags;
    this.myController.loadButtonData( aSportId );
  };
  
  this.onButtonDataLoaded = function()
  {
    this.myController.addQuickTweetButtons( $( this.myContainerSelector + " ul.dropdown-menu") );
    
    $( this.myContainerSelector + " #post_combo p" ).each( createDelegate( this.myController,
                                                               this.myController.addQuickTweetClick ));
    $( this.myContainerSelector + " #post_combo .quickTweetButton" ).dropdown();
  };
  
  this.updatePostForm = function( aForceTwitterFlag, aDefaultText )
  {
    this.myListener.updatePostForm( aForceTwitterFlag, aDefaultText + " " + this.myHashTags);
  }
  
}
