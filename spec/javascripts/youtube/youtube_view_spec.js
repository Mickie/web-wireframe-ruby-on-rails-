describe("YouTubeView", function() 
{
  var myYouTubeView = new Object();
  
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
      
      myYouTubeView.onSearchComplete(YouTubeData.videoSearchResponse.feed.entry)
    });
    
    it("builds a slideshow of thumbnails", function() 
    {
      expect($("div.slides_container").find("img").length).toEqual(2);
    });    
  });
  
});