describe("MediaSlider", function() 
{
  var myMediaSlider;

  beforeEach(function()
  {
    myMediaSlider = new MediaSlider("myMediaSlider");

    loadJasmineFixture('media_slider');
  });
  
  describe("onInstagramMediaLoaded", function()
  {
    beforeEach(function()
    {
      myMediaSlider.onInstagramMediaLoaded(InstagramData.mediaResponse.data);
    });

    it("should create the right number of media divs", function()
    {
      expect($("#myMediaSlider").find(".mediaThumbnail").length).toEqual(17);
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

});