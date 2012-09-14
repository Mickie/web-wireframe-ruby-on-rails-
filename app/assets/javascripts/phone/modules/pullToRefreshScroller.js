var PullToRefreshScroller = function(aScrollParent, aPullUpDivId, aPullDownDivId, aListener)
{
  this.myScrollParent = aScrollParent;
  this.myListener = aListener;
  this.myPullDownDivId = aPullDownDivId;
  this.myPullUpDivId = aPullUpDivId;

  this.myScroller;
  this.myPullDownDiv;
  this.myPullDownOffset;
  this.myPullUpDiv;
  this.myPullUpOffset;

  this.initialize = function()
  {
    if (this.myPullDownDivId)
    {
      this.myPullDownDiv = document.getElementById(this.myPullDownDivId);
      this.myPullDownOffset = this.myPullDownDiv.offsetHeight;
    }
    
    if (this.myPullUpDivId)
    {
      this.myPullUpDiv = document.getElementById(this.myPullUpDivId);
      this.myPullUpOffset = this.myPullUpDiv.offsetHeight;
    }

    this.myScroller = new iScroll(this.myScrollParent,
    {
      useTransition : true,
      topOffset: this.myPullDownOffset || 0,
      onRefresh : createDelegate(this, this.onRefresh),
      onScrollMove : createDelegate(this, this.onScrollMove),
      onScrollEnd : createDelegate(this, this.onScrollEnd)
    });
  }
  
  this.scrollToTop = function()
  {
    if (this.myScroller)
    {
      this.myScroller.scrollTo(0,0,0);
    }
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

  this.onRefresh = function()
  {
    if (this.myPullDownDiv && $(this.myPullDownDiv).hasClass('loading'))
    {
      $(this.myPullDownDiv).removeClass('loading');
      this.myPullDownDiv.querySelector('.pullDownLabel').innerHTML = 'Pull down to refresh...';
    }
    else if (this.myPullUpDiv && $(this.myPullUpDiv).hasClass('loading'))
    {
      $(this.myPullUpDiv).removeClass('loading');
      this.myPullUpDiv.querySelector('.pullUpLabel').innerHTML = 'Pull up to load more...';
    }
  }

  this.onScrollMove = function()
  {
    if (this.myPullDownDiv && this.myScroller.y > 5 && !$(this.myPullDownDiv).hasClass('flip'))
    {
      $(this.myPullDownDiv).addClass('flip');
      this.myPullDownDiv.querySelector('.pullDownLabel').innerHTML = 'Release to refresh...';
      this.minScrollY = 0;
    }
    else if (this.myPullDownDiv && this.myScroller.y < 5 && $(this.myPullDownDiv).hasClass('flip'))
    {
      $(this.myPullDownDiv).removeClass('flip');
      this.myPullDownDiv.querySelector('.pullDownLabel').innerHTML = 'Pull down to refresh...';
      this.myScroller.minScrollY = -this.myPullDownOffset;
    }
    else if (this.myPullUpDiv && this.myScroller.y < (this.myScroller.maxScrollY - 5) && !$(this.myPullUpDiv).hasClass('flip'))
    {
      $(this.myPullUpDiv).addClass('flip');
      this.myPullUpDiv.querySelector('.pullUpLabel').innerHTML = 'Release to refresh...';
      this.myScroller.maxScrollY = this.myScroller.maxScrollY;
    }
    else if (this.myPullUpDiv && this.y > (this.myScroller.maxScrollY + 5) && $(this.myPullUpDiv).hasClass('flip'))
    {
      $(this.myPullUpDiv).removeClass('flip');
      this.myPullUpDiv.querySelector('.pullUpLabel').innerHTML = 'Pull up to load more...';
      this.myScroller.maxScrollY = this.myPullUpOffset;
    }
  }

  this.onScrollEnd = function()
  {
    if (this.myPullDownDiv && $(this.myPullDownDiv).hasClass('flip'))
    {
      $(this.myPullDownDiv).removeClass('flip');
      $(this.myPullDownDiv).addClass('loading');
      this.myPullDownDiv.querySelector('.pullDownLabel').innerHTML = 'Loading...';
      this.myListener.pullDownAction();
    }
    else if (this.myPullUpDiv && $(this.myPullUpDiv).hasClass('flip'))
    {
      $(this.myPullUpDiv).removeClass('flip');
      $(this.myPullUpDiv).addClass('loading');
      this.myPullUpDiv.querySelector('.pullUpLabel').innerHTML = 'Loading...';
      this.myListener.pullUpAction();
    }
  }
}
