describe("YouTubeSearch", function() 
{
  var myYouTubeSearch;
  
  describe(".getQuery", function()
  {
    
    it("returns correct query for single tag", function() 
    {
      myYouTubeSearch = new YouTubeSearch("Notre Dame",
                                      "Football",
                                      ["#notredame"], 
                                      1);
      expect(myYouTubeSearch.getQuery()).toBe('"Notre Dame Football"|notredame'); 
    });
    
    it("returns correct query for multiple tags", function() 
    {
      myYouTubeSearch = new YouTubeSearch("Notre Dame",
                                      "Football",
                                      ["#notredame", "#goirish"], 
                                      1);
      expect(myYouTubeSearch.getQuery()).toBe('"Notre Dame Football"|notredame|goirish'); 
    });
  });
  
  describe("getting data", function()
  {
    beforeEach(function()
    {
      myYouTubeSearch = new YouTubeSearch("Notre Dame",
                                      "Football",
                                      ["#notredame", "#goirish"], 
                                      2);
      registerFakeAjax(
      { 
        url: "http://gdata.youtube.com/feeds/api/videos?alt=json-in-script&format=5,6&category=Sports&v=2&q=%22Notre%20Dame%20Football%22%7Cnotredame%7Cgoirish&max-results=2",
        successData: YouTubeData.videoSearchResponse
      })

      myYouTubeSearch.onSearchComplete = jasmine.createSpy('onSearchComplete');
      myYouTubeSearch.startVideoSearch(); 
    });

    it("calls onSearchComplete with results", function() 
    {
      expect(myYouTubeSearch.onSearchComplete).toHaveBeenCalled();
 
      var theArgs = myYouTubeSearch.onSearchComplete.mostRecentCall.args;

      expect(theArgs[0].version).toEqual("1.0");
      expect(theArgs[0].feed.entry.length).toEqual(2);
    });
  });

  describe("handling data response", function()
  {
    var myCallback;
    beforeEach(function()
    {
      myYouTubeSearch = new YouTubeSearch("Notre Dame",
                                      "Football",
                                      ["#notredame", "#goirish"], 
                                      2);

      myYouTubeSearch.myLoadCompleteCallback = jasmine.createSpy('onLoadComplete');
      myYouTubeSearch.onSearchComplete(YouTubeData.videoSearchResponse); 
    });

    it("calls callback with feed", function() 
    {
      expect(myYouTubeSearch.myLoadCompleteCallback).toHaveBeenCalledWith(YouTubeData.videoSearchResponse.feed.entry);
    });

    it("saves the response", function() 
    {
      expect(myYouTubeSearch.mySearchResults).toEqual(YouTubeData.videoSearchResponse);
    });
  });

});