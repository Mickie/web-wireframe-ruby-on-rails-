var InfiniteScroller = function()
{
  this.myCurrentPage = 1;
  this.myLoadingFlag = false;
  this.myResourceUrl = "";
  this.myOnScrollDelegate = null;

  function nearBottomOfPage() 
  {
    return $(window).scrollTop() > $(document).height() - $(window).height() - 200;
  }

  this.handleScrollingForResource = function(aResourceUrl)
  {
    this.myResourceUrl = aResourceUrl;
    this.myOnScrollDelegate = createDelegate( this, this.onScroll );
    $(window).on("scroll", this.myOnScrollDelegate);
  };

  this.stop = function()
  {
    $(window).off("scroll", this.myOnScrollDelegate);
    this.myOnScrollDelegate = null;
  };

  this.getUrlForCurrentPage = function()
  {
    return this.myResourceUrl + "?page=" + this.myCurrentPage;
  };

  this.onScroll = function(e)
  {
    if (this.myLoadingFlag) 
    {
      return;
    }
  
    if(nearBottomOfPage()) 
    {
      this.myLoadingFlag = true;
      this.myCurrentPage++;
      $.ajax({
        url: this.getUrlForCurrentPage(),
        type: 'get',
        dataType: 'script',
        complete: createDelegate(this, this.onLoadNextPageComplete)
      });
    }
  
  };
  
  this.onLoadNextPageComplete = function()
  {
    this.myLoadingFlag = false;    
  }

};

var myInfiniteScroller = new InfiniteScroller();
InfiniteScroller.get = function()
{
  return myInfiniteScroller;
};

