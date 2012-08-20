describe("BingSearch", function()  
{
  var myBingSearch;
  var onBingVideo, onBingImage, onBingNewsItem, onError, onSuccess;
  var THE_SEARCH_URL = "/teams/1/bing_search_results.json";
  
  beforeEach(function()
  {
    bingResultsReady = jasmine.createSpy('bingResultsReady');
    onError = jasmine.createSpy('onError');
    onSuccess = jasmine.createSpy('onSuccess');
    
    var theListener = {
      "bingResultsReady" : bingResultsReady,
      "onError" : onError,
      "onSuccess" : onSuccess
    };
    
    myBingSearch = new BingSearch(theListener);
  });
  
  describe("getSearchQuery", function()
  {
    it("returns a properly formatted query for id 1", function()
    {
      var theResult = myBingSearch.getSearchQuery("1");
      expect(theResult).toEqual(THE_SEARCH_URL);
    });

    it("returns a properly formatted query for id 2", function()
    {
      var theResult = myBingSearch.getSearchQuery("2");
      expect(theResult).toEqual("/teams/2/bing_search_results.json");
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
          data: BingSearchData,
          status: 'success'
        },
        complete:
        {
          status: 'success'
        }
      })

      myBingSearch.getSearchResultsForTeam( "1" ); 
    });

    it("calls bingResultsReady with an array of videos", function() 
    {
      expect(bingResultsReady).toHaveBeenCalled();
 
      var theArgs = bingResultsReady.mostRecentCall.args;

      expect(theArgs[0][1].ID).toEqual("912aa204-41e1-4158-b784-f945cbc24a6a");
    });
    
    it("calls bingResultsReady with an array of images", function() 
    {
      expect(bingResultsReady).toHaveBeenCalled();
 
      var theArgs = bingResultsReady.mostRecentCall.args;

      expect(theArgs[1][1].ID).toEqual("a82a5b6e-ba0d-4603-9623-c35cfa2d6d38");
    });
    
    it("calls bingResultsReady with an array of news items", function() 
    {
      expect(bingResultsReady).toHaveBeenCalled();
 
      var theArgs = bingResultsReady.mostRecentCall.args;

      expect(theArgs[2][1].ID).toEqual("e3b90390-e0e8-47da-82f4-047eb912cc4e");
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
          data: {"bad":"data"},
          status: 'bad error'
        },
        complete:
        {
          status: 'bad error'
        }
      })

      myBingSearch.getSearchResultsForTeam( "1" ); 
    });

    it("calls onError with error message", function() 
    {
      expect(onSuccess).wasNotCalled();
      expect(bingResultsReady).wasNotCalled();
      expect(onError).toHaveBeenCalled();
 
      var theArgs = onError.mostRecentCall.args;

      expect(theArgs[0]).toMatch(/.*bad error$/);
    });
  });

    
});
