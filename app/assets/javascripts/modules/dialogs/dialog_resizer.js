var DialogResizer = function()
{
  this.myOriginalHeight = 0;
  this.myOriginalWidth = 0;
  this.myCurrentDialog;

  this.initialize = function()
  {
    $("div#page_content").on('show', ".modal", createDelegate(this, this.onShow) );
    $("div#page_content").on('hidden', ".modal", createDelegate(this, this.onHidden) );
  };
  
  this.onShow = function(e)
  {
    this.myCurrentDialog = e.target;
    this.myOriginalHeight = $(this.myCurrentDialog).height();
    this.myOriginalWidth = $(this.myCurrentDialog).width();
    $(window).on('resize', createDelegate( this, this.onResize ) );

    setTimeout(createDelegate(this, this.refreshDimensions), 100);
    
    trackEvent("Dialog", "show", $(this.myCurrentDialog).attr("id"));
  };
  
  this.refreshDimensions = function()
  {
    this.myOriginalHeight = $(this.myCurrentDialog).height();
    this.myOriginalWidth = $(this.myCurrentDialog).width();
    this.onResize();
  };
  
  this.onResize = function(e)
  {
    this.updateHeight();
    this.updateWidth();
    this.centerDialog();
  };
  
  this.onHidden = function(e)
  {
    $(window).off('resize');
    $(this.myCurrentDialog).css("height", "auto");
    $(this.myCurrentDialog).css("width", "auto");

    trackEvent("Dialog", "hidden", $(this.myCurrentDialog).attr("id"));
  };
  
  this.updateHeight = function()
  {
    var theHeight = DimensionManager.get().getDimensions().height;
    
    if ( theHeight <= this.myOriginalHeight )
    {
      $(this.myCurrentDialog).css("height", (theHeight - 10) + "px");
    }
    else
    {
      $(this.myCurrentDialog).css("height", "auto");
    }
  };

  this.updateWidth = function()
  {
    var theDimensions = DimensionManager.get().getDimensions();
    
    if (theDimensions.width <= this.myOriginalWidth )
    {
      $(this.myCurrentDialog).css("width", (theDimensions.width - 10) + "px");
    }
    else
    {
      if (theDimensions.height <= this.myOriginalHeight )
      {
        $(this.myCurrentDialog).css("width", (this.myOriginalWidth + 15) + "px");
      }
      else
      {
        $(this.myCurrentDialog).css("width", "auto");
      }
    }
  };
  
  this.centerDialog = function()
  {
    var theWindowWidth = DimensionManager.get().getDimensions().width;
    var theModalWidth = $(this.myCurrentDialog).width();
    thePosition = (theWindowWidth - theModalWidth)/2;
    $(this.myCurrentDialog).css("left", thePosition + "px");
  };
}

var myDialogResizer;

$(function()
{
  myDialogResizer = new DialogResizer();
  myDialogResizer.initialize();
});

