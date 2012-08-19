describe("InstagramView", function() 
{
  var myInstagramView;

  beforeEach(function()
  {
    loadJasmineFixture('media_slider');
    myInstagramView = new InstagramView("div#myMediaSlider",
                                        "div#myInstagramModal",
                                        "div#postForm");
  });
  
  describe("onInstagramMediaLoaded", function()
  {
    beforeEach(function()
    {
      myInstagramView.onInstagramMediaLoaded(InstagramData.mediaResponse.data);
    });

    it("should create the right hash map to hold the data", function()
    {
      expect(myInstagramView.myInstagrams[0]).toEqual(InstagramData.mediaResponse.data[0]);
      expect(myInstagramView.myInstagrams[1]).toEqual(InstagramData.mediaResponse.data[1]);
      expect(myInstagramView.myInstagrams[2]).toEqual(InstagramData.mediaResponse.data[2]);
    });
  });
  
  describe("showImageDialog", function()
  {
    beforeEach(function()
    {
      myInstagramView.showImageDialog(InstagramData.mediaResponse.data[0]);
    });
    
    it("adds the correct image to the modal", function() 
    {
      expect($("div#myInstagramModal div.instagramImage img")).toHaveAttr("src", InstagramData.mediaResponse.data[0].images.low_resolution.url);
    });
    
    it("adds the correct title to the modal", function() 
    {
      expect($("div#myInstagramModal div.modal-header h3")).toHaveText(InstagramData.mediaResponse.data[0].user.full_name);
    });

    it("adds the correct profile image to the modal", function() 
    {
      expect($("div#myInstagramModal div.modal-header img")).toHaveAttr("src", InstagramData.mediaResponse.data[0].caption.from.profile_picture);
    });
    
  });
  
});