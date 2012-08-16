$(function()
{
  if (!window.location.hash || window.location.hash.length <= 1)
  {
    $('#allFanzones').addClass('active');
    InfiniteScroller.get().handleScrollingForResource("/tailgates");
  }
});
