var YOUTUBE_VIDEO_SEARCH_URL = buildUrl("gdata.youtube.com", "feeds/api/videos");
var myLocalYouTubeSearch = null;

function onYouTubeIframeAPIReady() 
{
  myLocalYouTubeSearch.onApiReady();
}

var YouTubeSearch = function( aShortName,
                              aSport, 
                              anArrayOfHashTags,
                              aMaxVideos)
{
  this.myShortName = aShortName;
  this.mySport = aSport;
  this.myHashTags = anArrayOfHashTags;
  this.myMaxVideos = aMaxVideos;
  this.myLoadCompleteCallback = null;
  this.mySearchResults = null;
  this.myAbortFlag = false;

  this.loadSDK = function()
  {
    myLocalYouTubeSearch = this;
    var theTag = document.createElement('script');
    theTag.src = buildUrl("www.youtube.com", "iframe_api");
    var theFirstScriptTag = document.getElementsByTagName('script')[0];
    theFirstScriptTag.parentNode.insertBefore(theTag, theFirstScriptTag);  
  }
  
  this.onApiReady = function()
  {
    if (this.myAbortFlag)
    {
      return;
    }
    this.startVideoSearch();
  };
  
  this.loadVideos = function( aLoadCompleteCallback )
  {
    this.myLoadCompleteCallback = aLoadCompleteCallback;
    if (myLocalYouTubeSearch)
    {
      this.startVideoSearch();
    }
    else
    {
      this.loadSDK();
    }
  };
  
  this.abort = function()
  {
    this.myAbortFlag = true;
    this.myLoadCompleteCallback = null;
  };

  this.startVideoSearch = function()
  {
    var theQueryString = "?alt=json-in-script&format=5,6&category=Sports&v=2&q=" 
                          + escape(this.getQuery()) 
                          + "&max-results=" + this.myMaxVideos;
    $.ajax({
             url: YOUTUBE_VIDEO_SEARCH_URL + theQueryString,
             cache:false,
             dataType: "jsonp",
             success: createDelegate(this, this.onSearchComplete)
           });
  };

  this.onSearchComplete = function( aResult )
  {
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.mySearchResults = aResult;
    
    var theEntries = aResult.feed.entry || [];
    this.myLoadCompleteCallback(theEntries);    
  };
  
  this.getQuery = function()
  {
    var theName = '"' + this.myShortName + ' ' + this.mySport + '"';
    return theName + '|' + this.myHashTags.join('|').replace(/#/g, "");
  };
    
};