describe("TwitterSearch", function() 
{
  var myTwitterSearch;
  var myRequest;
  var onTweet, onError;
  
  beforeEach(function()
  {
    jasmine.Ajax.useMock();
    
    onTweet = jasmine.createSpy('onTweet');
    onError = jasmine.createSpy('onError');
    
    myTwitterSearch = new TwitterSearch(onTweet, onError);
    
    myTwitterSearch.getLatestTweetsForTerm( 'notredame', 1);
    
  });
  
  describe("on success", function()
  {
    beforeEach(function() 
    {
      myRequest = mostRecentAjaxRequest();
//      myRequest.response(TwitterSearchResponses.search.success);
    });

    it("calls onTweet with an array of tweets", function() 
    {
      //expect(onTweet).toHaveBeenCalled();

      //var theArgs = onTweet.mostRecentCall.args[0];

      //expect(theArgs.results.length).toEqual(1);
      //expect(theArgs.results[0].id).toEqual(202854280347127809);
    });
  });
    
});
