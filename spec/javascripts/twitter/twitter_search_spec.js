describe("TwitterSearch", function()  
{
  var myTwitterSearch;
  var onTweet, onError;
  var THE_SEARCH_URL = 'http://search.twitter.com/search.json?lang=en&include_entities=true&q=notredame%20-dakota&rpp=1';
  
  beforeEach(function()
  {
    onTweet = jasmine.createSpy('onTweet');
    onError = jasmine.createSpy('onError');
    
    var theListener = {
      "onNewTweet" : onTweet,
      "onError" : onError
    };
    
    myTwitterSearch = new TwitterSearch(theListener);
  });
  
  describe("getSearchQuery", function()
  {
    it("returns a properly formatted query - no OR or not", function()
    {
      var theResult = myTwitterSearch.getSearchQuery(['notredame'], []);
      expect(theResult).toEqual("notredame");
    });

    it("returns a properly formatted query - with OR but no not", function()
    {
      var theResult = myTwitterSearch.getSearchQuery(['notredame', 'nd'], []);
      expect(theResult).toEqual("notredame OR nd");
    });

    it("returns a properly formatted query - no OR but a not", function()
    {
      var theResult = myTwitterSearch.getSearchQuery(['notredame'], ['dakota']);
      expect(theResult).toEqual("notredame -dakota");
    });

    it("returns a properly formatted query - with OR and not", function()
    {
      var theResult = myTwitterSearch.getSearchQuery(['notredame', 'nd'], ['dakota']);
      expect(theResult).toEqual("notredame OR nd -dakota");
    });

    it("returns a properly formatted query - with OR and multiple nots", function()
    {
      var theResult = myTwitterSearch.getSearchQuery(['notredame', 'nd'], ['dakota', 'north']);
      expect(theResult).toEqual("notredame OR nd -dakota -north");
    });
  });
  
  describe("on success", function()
  {
    beforeEach(function()
    {
      registerFakeAjax(
      { 
        url: THE_SEARCH_URL,
        successData: TwitterData.searchResponses.success
      })

      myTwitterSearch.getLatestTweetsForTerm( ['notredame'], ['dakota'], 1); 
    });

    it("calls onTweet with an array of tweets", function() 
    {
      expect(onTweet).toHaveBeenCalled();
 
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
          data: TwitterData.searchResponses.error,
          status: 'bad error'
        }
      })

      myTwitterSearch.getLatestTweetsForTerm( ['notredame'], ['dakota'], 1); 
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
