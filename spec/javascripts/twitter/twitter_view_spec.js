describe("TwitterView", function() 
{
  var myTwitterView = new Object();
  
  beforeEach(function()
  {
    
    myTwitterView = new TwitterView(["notredame"],
                                    [], 
                                    1,
                                    "tweets",
                                    "newTweets",
                                    "controls",
                                    true,
                                    1,
                                    1,
                                    "myTwitterView");

    loadJasmineFixture('twitter_view');
  });
  
  describe(".showNewTweetsAlert", function()
  {
    
    beforeEach(function()
    {
      $('div#newTweets').hide();
      myTwitterView.myNewTweets = [1,2];
      myTwitterView.showNewTweetsAlert();
    });
    
    it("shows the div", function() 
    {
      expect($('div#newTweets')).toBeVisible(); 
    });
    
    it("displays the correct text", function() 
    {
      expect($('div#newTweets > p')).toHaveHtml( "<strong>2</strong> new Tweets!" ); 
    });
  });
    
  describe(".chopOffOldestTweetsSoWeShowOnlyTheLatest", function()
  {
    
    it("handles fewer than max", function() 
    {
      myTwitterView.myMaxTweets = 10;
      myTwitterView.myNewTweets = [1,2,3,4];
      myTwitterView.chopOffOldestTweetsSoWeShowOnlyTheLatest();
      expect(myTwitterView.myNewTweets.length).toEqual(4);
    });
    
    it("handles more than max", function() 
    {
      myTwitterView.myMaxTweets = 3;
      myTwitterView.myNewTweets = [1,2,3,4,5,6,7];
      myTwitterView.chopOffOldestTweetsSoWeShowOnlyTheLatest();
      expect(myTwitterView.myNewTweets.length).toEqual(3);
    });
  });
    
  describe(".generateTweetDiv", function()
  {
    var theResult; 
        
    beforeEach(function()
    {
      theResult = myTwitterView.generateTweetDiv(TwitterData.tweet);
    });
    
    it("gives the tweet the correct id", function() 
    {
      expect(theResult).toHaveId(TwitterData.tweet.id); 
    });

    it("stuffs the correct name in the name div", function() 
    {
      expect(theResult.find("div.twitterName")).toHaveText(TwitterData.tweet.from_user_name); 
    });
    
    it("wraps urls in the tweet text", function() 
    {
      expect(theResult.find("span.twitterText")).toContain('a'); 
    });
    
  });
  
  describe(".makeInlineUrlsLinks", function()
  {
    var theResult; 
        
    beforeEach(function()
    {
      theResult = myTwitterView.makeInlineUrlsLinks( TwitterData.tweet.text, 
                                                     TwitterData.tweet.entities.urls);
    });
    
    it("should wrap the url with an anchor tag", function() 
    {
      expect($('<span>' + theResult + '</span>')).toContain("a"); 
    });

    it("should have the correct url in the anchor tag", function() 
    {
      expect($('<span>' + theResult + '</span>').find('a')).toHaveAttr("href", TwitterData.tweet.entities.urls[0].url); 
    });
    
  });


});
