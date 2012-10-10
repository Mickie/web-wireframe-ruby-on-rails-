var BaseThumbnail = function( aView )
{
  this.myView = aView;
  this.myData;
  this.myElement;
  this.myAbortFlag = false;
  
  this.initialize = function( aData, anElement )
  {
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.myData = aData;
    this.myElement = anElement;
    
    try
    {
      this.myElement = anElement.render( this.myData, this.getRenderDirective() );
      this.myElement.click( createDelegate(this, this.onClick ) );
    }
    catch(anError)
    {
      console.log(anError);
    }

  };
  
  this.cleanup = function()
  {
    this.myAbortFlag = true;
    this.myElement.remove();
  }
  
  this.onClick = function()
  {
    this.myView.showDialog(this.myData);
  };
  
  this.getRenderDirective = function()
  {
    throw("abstract method called, did you forget to override it?");
  };
  
}
