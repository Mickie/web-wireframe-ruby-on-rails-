describe("YoutubeView", function() 
{
  var myYoutubeView;

  beforeEach(function()
  {
    loadJasmineFixture('media_slider');
    myYoutubeView = new YoutubeView("div#myMediaSlider",
                                        "div#myMediaModal",
                                        "div#postForm");
  });
  
  describe("onYouTubeMediaLoaded", function()
  {
    beforeEach(function()
    {
      myYoutubeView.onYouTubeMediaLoaded(YouTubeData.videoSearchResponse.feed.entry);
    });

    it("should create the right hash map to hold the data", function()
    {
      expect(myYoutubeView.myYouTubeVideos[0]).toEqual(YouTubeData.videoSearchResponse.feed.entry[0]);
      expect(myYoutubeView.myYouTubeVideos[1]).toEqual(YouTubeData.videoSearchResponse.feed.entry[1]);
    });
  });
  

  describe("showDialog", function()
  {
    beforeEach(function()
    {
      myYoutubeView.myDialogPlayer = { loadVideoById: function(){} };
      myYoutubeView.showDialog(YouTubeData.videoSearchResponse.feed.entry[0]);
    });
    
    it("adds the correct title to the modal", function() 
    {
      expect($("div#myMediaModal div.modal-body h3.mediaTitle")).toHaveText(YouTubeData.videoSearchResponse.feed.entry[0].title.$t);
    });
    
  });
  
  
});