var InstagramThumbnail = function( anInstagramView )
{
  this.myView = anInstagramView;
  this.myData;
  this.myElement;
  
  this.initialize = function( aData, anElement )
  {
    this.myData = aData;
    this.myElement = anElement;
    
    try
    {
      this.myElement.render( this.myData, this.getInstagramDirective() ).click( createDelegate(this, this.onClick ) );
    }
    catch(anError)
    {
      console.log(anError);
    }
  };
  
  this.onClick = function()
  {
    this.myView.showImageDialog(this.myData);
  }
  
  this.getInstagramDirective = function()
  {
    return {
      ".@id" : "id",
      "div.media img@style" : function(anItem){return "";},
      "div.media img@src" : "images.thumbnail.url",
      "div.media img@width" : "images.thumbnail.width",
      "div.media img@height" : "images.thumbnail.height"
    }    
  };
  
}
