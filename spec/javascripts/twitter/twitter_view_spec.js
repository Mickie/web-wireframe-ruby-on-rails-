describe("TwitterView", function() 
{
  var myTwitterView = new Object();
  
  beforeEach(function()
  {
    
    myTwitterView = new TwitterView(["notredame"], 
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
  
  describe(".onError", function()
  {
    var theExpectedText = "test text"; 

    beforeEach(function()
    {
      myTwitterView.onError( theExpectedText );
    });
    
    it("drops an error message into the new tweets dive", function() 
    {
      expect($('div#newTweets > p')).toHaveText( "Woops: " + theExpectedText + " we will try again in 5 seconds" ); 
    });
  });
  
});
