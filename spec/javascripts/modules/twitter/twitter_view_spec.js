describe("TwitterView", function() 
{
  var myTwitterView = new Object();
  
  beforeEach(function()
  {
    
    myTwitterView = new TwitterView(1,
                                    "tweets",
                                    "newTweets",
                                    {});

    loadJasmineFixture('twitter_view');
  });
  
  describe(".showNewTweetsAlert", function()
  {
    
    beforeEach(function()
    {
      myTwitterView.showNewTweetsAlert(2);
    });
    
    it("shows the div", function() 
    {
      expect($('div#newTweets')).toBeVisible(); 
    });
    
    it("displays the correct text", function() 
    {
      expect($('div#newTweets > p')).toContainHtml( "<strong>2</strong> new Tweets!" ); 
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
