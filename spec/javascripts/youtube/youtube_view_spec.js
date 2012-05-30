describe("YouTubeView", function() 
{
  var myYouTubeView = new Object();
  
  describe(".getQuery", function()
  {
    
    it("returns correct query for single tag", function() 
    {
      myYouTubeView = new YouTubeView("Notre Dame",
                                      "Football",
                                      ["#notredame"], 
                                      1,
                                      "youtube");
      expect(myYouTubeView.getQuery()).toBe('"Notre Dame Football"|notredame'); 
    });
    
    it("returns correct query for multiple tags", function() 
    {
      myYouTubeView = new YouTubeView("Notre Dame",
                                      "Football",
                                      ["#notredame", "#goirish"], 
                                      1,
                                      "youtube");
      expect(myYouTubeView.getQuery()).toBe('"Notre Dame Football"|notredame|goirish'); 
    });
  });
  
  describe("getting data", function()
  {
    beforeEach(function()
    {
      myYouTubeView = new YouTubeView("Notre Dame",
                                      "Football",
                                      ["#notredame", "#goirish"], 
                                      2,
                                      "youtube");
      registerFakeAjax(
      { 
        url: "http://gdata.youtube.com/feeds/api/videos?alt=json-in-script&format=5,6&hd&category=Sports&v=2&q=%22Notre%20Dame%20Football%22%7Cnotredame%7Cgoirish&max-results=2",
        successData: YouTubeData.videoSearchResponse
      })

      myYouTubeView.onSearchComplete = jasmine.createSpy('onSearchComplete');
      myYouTubeView.loadVideos(); 
    });

    it("calls onSearchComplete with results", function() 
    {
      expect(myYouTubeView.onSearchComplete).toHaveBeenCalled();
 
      var theArgs = myYouTubeView.onSearchComplete.mostRecentCall.args;

      expect(theArgs[0].version).toEqual("1.0");
      expect(theArgs[0].feed.entry.length).toEqual(2);
    });
  });
  
  describe("handling data", function()
  {
    beforeEach(function()
    {
      loadJasmineFixture('youtube_view');
      myYouTubeView = new YouTubeView("Notre Dame",
                                      "Football",
                                      ["#notredame", "#goirish"], 
                                      2,
                                      "youtube");
      
      myYouTubeView.onSearchComplete(YouTubeData.videoSearchResponse)
    });
    
    it("builds a slideshow of thumbnails", function() 
    {
      expect($("div.slides_container").find("img").length).toEqual(2);
    });    
  });
  
});