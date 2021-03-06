describe("BingView", function() 
{
  var myBingView;

  beforeEach(function()
  {
    loadJasmineFixture('media_slider');
    myBingView = new BingView("div#myMediaSlider",
                              "div#myMediaModal",
                              "div#postForm");
  });
  
  describe("onBingResultsReady", function()
  {
    beforeEach(function()
    {
      myBingView.onBingResultsReady(BingSearchData.d.results[0].Video,
                                    BingSearchData.d.results[0].Image,
                                    BingSearchData.d.results[0].News);
    });

    it("should save the data", function()
    {
      expect(myBingView.myBingVideos[0]).toEqual(BingSearchData.d.results[0].Video[0]);
      expect(myBingView.myBingImages[0]).toEqual(BingSearchData.d.results[0].Image[0]);
      expect(myBingView.myBingNews[0]).toEqual(BingSearchData.d.results[0].News[0]);
    });
  });
  
  describe("isYoutubeVideo", function()
  {
    it("should reject a non youtube video", function()
    {
      expect(myBingView.isYoutubeVideo(BingSearchData.d.results[0].Video[0].MediaUrl)).toBeFalsy();
    });
    
    it("should correctly id a youtube video", function()
    {
      expect(myBingView.isYoutubeVideo("http://www.youtube.com/watch?v=12345")).toBeTruthy();
    });
  });
  
  describe("getIdFromYoutubeUrl", function()
  {
    it("should return the id", function()
    {
      expect(myBingView.getIdFromYoutubeUrl("http://www.youtube.com/watch?v=12345")).toEqual("12345");
    });
    
  });
  
  describe("showDialog for bing image", function()
  {
    beforeEach(function()
    {
      myBingView.showDialog(BingSearchData.d.results[0].Image[1]);
    });
    
    it("adds the correct image to the modal", function() 
    {
      expect($("div#myMediaModal div.mediaImage img")).toHaveAttr("src", BingSearchData.d.results[0].Image[1].MediaUrl);
    });
    
    it("adds the correct title to the modal", function() 
    {
      expect($("div#myMediaModal div.modal-body h3.mediaTitle")).toHaveText(BingSearchData.d.results[0].Image[1].Title);
    });
  });
  
});