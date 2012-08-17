describe("TwitterSearch", function()  
{
  var myTwitterSearch;
  var onNewTweet, onError, onSuccess;
  var THE_SEARCH_URL = 'http://search.twitter.com/search.json?lang=en&include_entities=true&q=notredame%20-dakota&rpp=1';
  
  beforeEach(function()
  {
    onNewTweet = jasmine.createSpy('onNewTweet');
    onError = jasmine.createSpy('onError');
    onSuccess = jasmine.createSpy('onSuccess');
    
    var theListener = {
      "onNewTweet" : onNewTweet,
      "onError" : onError,
      "onSuccess" : onSuccess
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
        success: {
          data: TwitterData.searchResponses.success,
          status: 'success'
        },
        complete:
        {
          status: 'success'
        }
      })

      myTwitterSearch.getLatestTweetsForTerm( ['notredame'], ['dakota'], 1); 
    });

    it("calls onNewTweet with a tweet", function() 
    {
      expect(onNewTweet).toHaveBeenCalled();
 
      var theArgs = onNewTweet.mostRecentCall.args;

      expect(theArgs[0]).toEqual(0);
      expect(theArgs[1].id).toEqual(202854280347127809);
    });
    
    it ("calls onSuccess when done", function()
    {
      expect(onSuccess).toHaveBeenCalled();
      expect(onError).wasNotCalled();
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
        },
        complete:
        {
          status: 'bad error'
        }
      })

      myTwitterSearch.getLatestTweetsForTerm( ['notredame'], ['dakota'], 1); 
    });

    it("calls onError with error message", function() 
    {
      expect(onSuccess).wasNotCalled();
      expect(onNewTweet).wasNotCalled();
      expect(onError).toHaveBeenCalled();
 
      var theArgs = onError.mostRecentCall.args;

      expect(theArgs[0]).toMatch(/.*bad error$/);
    });
  });

    
});
