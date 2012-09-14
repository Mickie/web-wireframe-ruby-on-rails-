var PullToRefreshScroller = function( aScrollParent, aListener )
{
  this.myScrollParent = aScrollParent;
  this.myListener = aListener;
  
  this.myScroller;
  
  this.initialize = function()
  {
    this.myScroller = new iScroll( this.myScrollParent );
  }
  
  this.cleanup = function()
  {
    if (this.myScroller)
    {
      this.myScroller.destroy()
      this.myScroller = null;
    }
  }
  
  this.update = function()
  {
    if (this.myScroller)
    {
      this.myScroller.refresh();
    }
  }
  
}
