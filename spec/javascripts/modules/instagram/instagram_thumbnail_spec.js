describe("InstagramThumbnail", function() 
{
  var myInstagramThumbnail;

  beforeEach(function()
  {
    onShowDialog = jasmine.createSpy('showDialog');
    
    var theView = {
      "onShowDialog" : onShowDialog
    };

    loadJasmineFixture('media_slider');
    myInstagramThumbnail = new InstagramThumbnail(theView);
  });
  

  describe("initialize", function()
  {
    beforeEach(function()
    {
      var theElement = $("div#myMediaTemplate").clone();
      myInstagramThumbnail.initialize(InstagramData.mediaResponse.data[0], theElement);
    });
    
    it("creates a div with correct id and class", function() 
    {
      expect(myInstagramThumbnail.myElement).toBeDefined(); 
      expect(myInstagramThumbnail.myElement).toHaveId(InstagramData.mediaResponse.data[0].id); 
      expect(myInstagramThumbnail.myElement).toHaveClass("mediaThumbnail"); 
    });

    it("puts an image with correct url in the div", function() 
    {
      expect(myInstagramThumbnail.myElement.find("img.mediaImage")).toHaveAttr("src", InstagramData.mediaResponse.data[0].images.thumbnail.url); 
    });
    
    it("gives the image the correct dimensions", function() 
    {
      expect(myInstagramThumbnail.myElement.find("img.mediaImage")).toHaveAttr("width", "150"); 
      expect(myInstagramThumbnail.myElement.find("img.mediaImage")).toHaveAttr("height", "150"); 
    });

    it("gives the image the correct alt text", function() 
    {
      expect(myInstagramThumbnail.myElement.find("img.mediaImage")).toHaveAttr("alt", InstagramData.mediaResponse.data[0].caption.text);
    });

    it("gives the div a click handler", function() 
    {
      expect(myInstagramThumbnail.myElement).toHandle("click");
    });
    
  });
  
  
});