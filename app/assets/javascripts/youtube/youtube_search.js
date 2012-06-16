var YOUTUBE_VIDEO_SEARCH_URL = "http://gdata.youtube.com/feeds/api/videos";
var myLocalYouTubeSearch;

function onYouTubePlayerAPIReady() 
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
  this.myApiReadyFlag = false;

  this.loadSDK = function()
  {
    myLocalYouTubeSearch = this;
    var theTag = document.createElement('script');
    theTag.src = "http://www.youtube.com/player_api";
    var theFirstScriptTag = document.getElementsByTagName('script')[0];
    theFirstScriptTag.parentNode.insertBefore(theTag, theFirstScriptTag);  
  }
  
  this.onApiReady = function()
  {
    this.myApiReadyFlag = true;
    this.startVideoSearch();
  };
  
  this.loadVideos = function( aLoadCompleteCallback )
  {
    this.myLoadCompleteCallback = aLoadCompleteCallback;
    if (this.myApiReadyFlag)
    {
      this.startVideoSearch();
    }
    else
    {
      this.loadSDK();
    }
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