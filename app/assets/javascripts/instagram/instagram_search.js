var InstagramSearch = function()
{
  this.myTeamId;
  this.myMediaResponseCount = 0;
  this.myCompleteCallback;
  this.myMedia = [];
  
  this.loadMediaForTeam = function( aTeamId, aCompleteCallback )
  {
    this.myTeamId = aTeamId;
    this.myCompleteCallback = aCompleteCallback;
  };
  
  this.getTags = function()
  {
    $.getJSON("/instagram_proxy/find_tags.json?team_id=" + this.myTeamId, 
              createDelegate(this, this.onGetTagsComplete));
  };
  
  this.onGetTagsComplete = function(aResult)
  {
    this.myTags = aResult;
    
    this.myMediaResponseCount = 0;
    for (var i=0; i < this.myTags.length; i++) 
    {
      this.getMediaForTag(this.myTags[i].name);
    };
  };
  
  this.getMediaForTag = function( aTag )
  {
    $.getJSON("/instagram_proxy/media_for_tag?tag=" + escape(aTag),
              createExtendedDelegate(this, this.onGetMediaForTagComplete, [aTag]));
  };
  
  this.onGetMediaForTagComplete = function(aResult, aTextStatus, aJQXHR, aTag)
  {
    this.myMedia = this.myMedia.concat(aResult.data);
    
    this.myMediaResponseCount++;
    if (this.myMediaResponseCount == this.myTags.length)
    {
      this.myCompleteCallback();
    }
  };
}
