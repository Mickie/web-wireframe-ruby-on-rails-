describe("InstagramSearch", function() 
{
  var myInstagramSearch;

  beforeEach(function()
  {
    myInstagramSearch = new InstagramSearch();
  });

  describe("getTagsForTeam", function()
  {
    beforeEach(function()
    {
      registerFakeAjax(
      { 
        url: "/instagram_proxy/find_tags_for_team.json?team_id=1",
        successData: InstagramData.tagsResponse
      })

      myInstagramSearch.onGetTagsComplete = jasmine.createSpy('onGetTagsComplete');
      myInstagramSearch.getTagsForTeam(1); 
    });

    it("calls onGetTagsComplete with results", function() 
    {
      expect(myInstagramSearch.onGetTagsComplete).toHaveBeenCalledWith(InstagramData.tagsResponse);
    });
  });

  describe("getTagsForFanzone", function()
  {
    beforeEach(function()
    {
      registerFakeAjax(
      { 
        url: "/instagram_proxy/find_tags_for_fanzone.json?fanzone_id=1",
        successData: InstagramData.tagsResponse
      })

      myInstagramSearch.onGetTagsComplete = jasmine.createSpy('onGetTagsComplete');
      myInstagramSearch.getTagsForFanzone(1); 
    });

    it("calls onGetTagsComplete with results", function() 
    {
      expect(myInstagramSearch.onGetTagsComplete).toHaveBeenCalledWith(InstagramData.tagsResponse);
    });
  });

  
  describe("onGetTagsComplete", function()
  {
    beforeEach(function()
    {
      myInstagramSearch.getMediaForTag = jasmine.createSpy('getMediaForTag');
      myInstagramSearch.onGetTagsComplete(InstagramData.tagsResponse); 
    });
    
    it("gets media for tags", function()
    {
      expect(myInstagramSearch.getMediaForTag).toHaveBeenCalledWith("nd");
      expect(myInstagramSearch.getMediaForTag).toHaveBeenCalledWith("goIrish");
 
      expect(myInstagramSearch.myTags[0].name).toEqual("nd");
      expect(myInstagramSearch.myTags[1].name).toEqual("goIrish");
    })
  });
  
  describe("getMediaForTag", function()
  {
    beforeEach(function()
    {
      registerFakeAjax(
      { 
        url: "/instagram_proxy/media_for_tag?tag=nd",
        successData: InstagramData.mediaResponse
      })

      myInstagramSearch.onGetMediaForTagComplete = jasmine.createSpy('onGetMediaForTagComplete');
      myInstagramSearch.getMediaForTag("nd"); 
    });

    it("calls onGetMediaForTagComplete with results", function() 
    {
      expect(myInstagramSearch.onGetMediaForTagComplete).toHaveBeenCalledWith(InstagramData.mediaResponse, "nd");
 
    });
  });

  describe("onGetMediaForTagComplete", function()
  {
    beforeEach(function()
    {
      myInstagramSearch.myCompleteCallback = jasmine.createSpy('onComplete');
      myInstagramSearch.myTags = InstagramData.tagsResponse;
      myInstagramSearch.onGetMediaForTagComplete(InstagramData.mediaResponse, "success", null, "nd"); 
    });
    
    it("sends complete notification when all tags are done", function()
    {
      expect(myInstagramSearch.myCompleteCallback).wasNotCalled();
      myInstagramSearch.onGetMediaForTagComplete(InstagramData.mediaResponse, "success", null, "goIrish");       
      expect(myInstagramSearch.myCompleteCallback).toHaveBeenCalledWith(InstagramData.mediaResponse.data.concat(InstagramData.mediaResponse.data));
    });
    
    it("stores data for access", function()
    {
      expect(myInstagramSearch.myMedia.length).toEqual(16);
      expect(myInstagramSearch.myMedia[0].images).toBeDefined();
    })

    it("appends additional results", function()
    {
      myInstagramSearch.onGetMediaForTagComplete(InstagramData.mediaResponse, "success", null, "goIrish"); 
      expect(myInstagramSearch.myMedia.length).toEqual(32);
    })

  });
  
  
});