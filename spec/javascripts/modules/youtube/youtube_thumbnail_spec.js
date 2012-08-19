describe("YoutubeThumbnail", function() 
{
  var myYoutubeThumbnail;

  beforeEach(function()
  {
    loadJasmineFixture('media_slider');
    myYoutubeThumbnail = new YoutubeThumbnail();
  });
  

  describe("initialize", function()
  {
    beforeEach(function()
    {
      var theElement = $("div#myMediaTemplate").clone().attr("id", "");
      myYoutubeThumbnail.initialize(YouTubeData.videoSearchResponse.feed.entry[0], theElement);
    });
    
    it("creates a div with correct id and class", function() 
    {
      expect(myYoutubeThumbnail.myElement).toBeDefined(); 
      expect(myYoutubeThumbnail.myElement).toHaveId(YouTubeData.videoSearchResponse.feed.entry[0].media$group.yt$videoid.$t); 
      expect(myYoutubeThumbnail.myElement).toHaveClass("mediaThumbnail"); 
    });

    it("puts an image with correct url in the div", function() 
    {
      expect(myYoutubeThumbnail.myElement.find("img.mediaImage")).toHaveAttr("src", YouTubeData.videoSearchResponse.feed.entry[0].media$group.media$thumbnail[0].url); 
    });
    
    it("gives the image the correct dimensions", function() 
    {
      expect(myYoutubeThumbnail.myElement.find("img.mediaImage")).toHaveAttr("width", "200"); 
      expect(myYoutubeThumbnail.myElement.find("img.mediaImage")).toHaveAttr("height", "150"); 
    });

    it("gives the image the correct alt text", function() 
    {
      expect(myYoutubeThumbnail.myElement.find("img.mediaImage")).toHaveAttr("alt", YouTubeData.videoSearchResponse.feed.entry[0].title.$t);
    });

    it("gives the div a click handler", function() 
    {
      expect(myYoutubeThumbnail.myElement).toHandle("click");
    });
    
  });
  
  
});