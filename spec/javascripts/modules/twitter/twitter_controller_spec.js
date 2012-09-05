describe("TwitterController", function() 
{
  var myTwitterController = {};
  
  beforeEach(function()
  {
    myTwitterController = new TwitterController(null, null);
  });
  
  describe(".chopOffOldestTweetsSoWeShowOnlyTheLatest", function()
  {
    
    it("handles fewer than max", function() 
    {
      myTwitterController.myMaxTweets = 10;
      myTwitterController.myNewTweets = [1,2,3,4];
      myTwitterController.chopOffOldestTweetsSoWeShowOnlyTheLatest();
      expect(myTwitterController.myNewTweets.length).toEqual(4);
    });
    
    it("handles more than max", function() 
    {
      myTwitterController.myMaxTweets = 3;
      myTwitterController.myNewTweets = [1,2,3,4,5,6,7];
      myTwitterController.chopOffOldestTweetsSoWeShowOnlyTheLatest();
      expect(myTwitterController.myNewTweets.length).toEqual(3);
    });
  });
});