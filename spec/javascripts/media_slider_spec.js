describe("MediaSlider", function() 
{
  var myMediaSlider; 

  beforeEach(function()
  {
    myMediaSlider = new MediaSlider("div#media_slider_spec div#myMediaSlider", "div#media_slider_spec div#myVideoModal");

    loadJasmineFixture('media_slider');
  });
  
  describe("onInstagramMediaLoaded", function()
  {
    beforeEach(function()
    {
      myMediaSlider.onInstagramMediaLoaded(InstagramData.mediaResponse.data);
    });

    it("should create the right hash map to hold the data", function()
    {
      expect(myMediaSlider.myInstagrams[InstagramData.mediaResponse.data[0].id]).toEqual(InstagramData.mediaResponse.data[0]);
      expect(myMediaSlider.myInstagrams[InstagramData.mediaResponse.data[1].id]).toEqual(InstagramData.mediaResponse.data[1]);
      expect(myMediaSlider.myInstagrams[InstagramData.mediaResponse.data[2].id]).toEqual(InstagramData.mediaResponse.data[2]);
    });
  });
  
  describe("onYouTubeMediaLoaded", function()
  {
    beforeEach(function()
    {
      myMediaSlider.onYouTubeMediaLoaded(YouTubeData.videoSearchResponse.feed.entry);
    });

    it("should create the right hash map to hold the data", function()
    {
      expect(myMediaSlider.myYouTubeVideos[YouTubeData.videoSearchResponse.feed.entry[0].media$group.yt$videoid.$t]).toEqual(YouTubeData.videoSearchResponse.feed.entry[0]);
      expect(myMediaSlider.myYouTubeVideos[YouTubeData.videoSearchResponse.feed.entry[1].media$group.yt$videoid.$t]).toEqual(YouTubeData.videoSearchResponse.feed.entry[1]);
    });
  });
  
  describe("onAllMediaLoaded", function()
  {
    beforeEach(function()
    {
      myMediaSlider.myInstagrams = {};
      myMediaSlider.myInstagrams[InstagramData.mediaResponse.data[0].id] = InstagramData.mediaResponse.data[0];

      myMediaSlider.myYouTubeVideos = {};
      myMediaSlider.myYouTubeVideos[YouTubeData.videoSearchResponse.feed.entry[0].media$group.yt$videoid.$t] = YouTubeData.videoSearchResponse.feed.entry[0];

      myMediaSlider.onAllMediaLoaded();
    });

    it("should create the right number of media divs", function()
    {
      expect($("#myMediaContent").find(".mediaThumbnail").length).toEqual(2);
    });
  });

  describe("onAllMediaLoaded is called when all media is loaded", function()
  {
    beforeEach(function()
    {
      myMediaSlider.onAllMediaLoaded = jasmine.createSpy('onAllMediaLoaded');
    });
      
    it("doesn't call onAllMediaLoaded with only instagram loaded", function() 
    {
      myMediaSlider.onInstagramMediaLoaded(InstagramData.mediaResponse.data);
      expect(myMediaSlider.onAllMediaLoaded).wasNotCalled();
    });

    it("doesn't call onAllMediaLoaded with only youtube loaded", function() 
    {
      myMediaSlider.onYouTubeMediaLoaded(YouTubeData.videoSearchResponse.feed.entry);
      expect(myMediaSlider.onAllMediaLoaded).wasNotCalled();
    });

    it("calls onAllMediaLoaded when both loaded, youtube last", function() 
    {
      myMediaSlider.onInstagramMediaLoaded(InstagramData.mediaResponse.data);
      myMediaSlider.onYouTubeMediaLoaded(YouTubeData.videoSearchResponse.feed.entry);
      expect(myMediaSlider.onAllMediaLoaded).toHaveBeenCalled();
    });

    it("calls onAllMediaLoaded when both loaded, instagram last", function() 
    {
      myMediaSlider.onYouTubeMediaLoaded(YouTubeData.videoSearchResponse.feed.entry);
      myMediaSlider.onInstagramMediaLoaded(InstagramData.mediaResponse.data);
      expect(myMediaSlider.onAllMediaLoaded).toHaveBeenCalled();
    });
  });

  describe("generateMediaDivFromInstagram", function()
  {
    var theResult; 
        
    beforeEach(function()
    {
      theResult = myMediaSlider.generateMediaDivFromInstagram(InstagramData.mediaResponse.data[0]);
    });
    
    it("creates a div with correct id and class", function() 
    {
      expect(theResult).toBeDefined(); 
      expect(theResult).toHaveId(InstagramData.mediaResponse.data[0].id); 
      expect(theResult).toHaveClass("mediaThumbnail"); 
    });

    it("puts an image with correct url in the div", function() 
    {
      expect(theResult.find("img.mediaImage")).toHaveAttr("src", InstagramData.mediaResponse.data[0].images.thumbnail.url); 
    });
    
    it("gives the image the correct dimensions", function() 
    {
      expect(theResult.find("img.mediaImage")).toHaveAttr("width", "150"); 
      expect(theResult.find("img.mediaImage")).toHaveAttr("height", "150"); 
    });

    it("gives the image a click handler", function() 
    {
      expect(theResult.find("img.mediaImage")).toHandle("click");
    });
    
  });

  describe("generateMediaDivFromYouTube", function()
  {
    var theResult; 
        
    beforeEach(function()
    {
      theResult = myMediaSlider.generateMediaDivFromYouTube(YouTubeData.videoSearchResponse.feed.entry[0]);
    });
    
    it("creates a div with correct id and class", function() 
    {
      expect(theResult).toBeDefined(); 
      expect(theResult).toHaveId(YouTubeData.videoSearchResponse.feed.entry[0].media$group.yt$videoid.$t); 
      expect(theResult).toHaveClass("mediaThumbnail"); 
    });

    it("puts an image with correct url in the div", function() 
    {
      expect(theResult.find("img.mediaImage")).toHaveAttr("src", YouTubeData.videoSearchResponse.feed.entry[0].media$group.media$thumbnail[0].url); 
    });
    
    it("gives the image the correct dimensions", function() 
    {
      expect(theResult.find("img.mediaImage")).toHaveAttr("width", "200"); 
      expect(theResult.find("img.mediaImage")).toHaveAttr("height", "150"); 
    });

    it("gives the image a click handler", function() 
    {
      expect(theResult.find("img.mediaImage")).toHandle("click");
    });
    
  });

});