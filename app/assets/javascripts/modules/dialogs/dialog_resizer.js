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
    this.onResize(e);
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
  };
  
  this.updateHeight = function()
  {
    if ($(window).height() <= this.myOriginalHeight )
    {
      $(this.myCurrentDialog).css("height", ($(window).height() - 10) + "px");
    }
    else
    {
      $(this.myCurrentDialog).css("height", "auto");
    }
  };

  this.updateWidth = function()
  {
    if ($(window).width() <= this.myOriginalWidth )
    {
      $(this.myCurrentDialog).css("width", ($(window).width() - 10) + "px");
    }
    else
    {
      if ($(window).height() <= this.myOriginalHeight )
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
    var theWindowWidth = $(window).width();
    var theModalWidth = $(this.myCurrentDialog).width();
    thePosition = (theWindowWidth - theModalWidth)/2;
    $(this.myCurrentDialog).css("left", thePosition + "px");
  };
}

$(function()
{
  var theResizer = new DialogResizer();
  theResizer.initialize();
});

