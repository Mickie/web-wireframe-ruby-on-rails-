describe("TwitterSearch", function() 
{
  var myTwitterSearch;
  var myRequest;
  var onTweet, onError;
  var THE_SEARCH_URL = 'http://search.twitter.com/search.json?lang=en&include_entities=true&q=notredame&rpp=1';
  
  beforeEach(function()
  {
    onTweet = jasmine.createSpy('onTweet');
    onError = jasmine.createSpy('onError');
    
    myTwitterSearch = new TwitterSearch(onTweet, onError);
  });
  
  describe("on success", function()
  {
    beforeEach(function()
    {
      registerFakeAjax(
      { 
        url: THE_SEARCH_URL,
        successData: TwitterSearchResponses.search.success
      })

      myTwitterSearch.getLatestTweetsForTerm( 'notredame', 1); 
    });

    it("calls onTweet with an array of tweets", function() 
    {
      expect(onTweet).toHaveBeenCalled();
      expect(onError).wasNotCalled();
 
      var theArgs = onTweet.mostRecentCall.args;

      expect(theArgs[0]).toEqual(0);
      expect(theArgs[1].id).toEqual(202854280347127809);
    });
  });

  describe("on error", function()
  {
    beforeEach(function()
    {
      registerFakeAjax(
      { 
        url: THE_SEARCH_URL,
        success: 
        {
          data: TwitterSearchResponses.search.error,
          status: 'bad error'
        }
      })

      myTwitterSearch.getLatestTweetsForTerm( 'notredame', 1); 
    });

    it("calls onError with error message", function() 
    {
      expect(onTweet).wasNotCalled();
      expect(onError).toHaveBeenCalled();
 
      var theArgs = onError.mostRecentCall.args;

      expect(theArgs[0]).toMatch(/.*bad error$/);
    });
  });

    
});
