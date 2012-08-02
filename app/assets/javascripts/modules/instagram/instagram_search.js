var InstagramSearch = function()
{
  this.myMediaResponseCount = 0;
  this.myCompleteCallback;
  this.myMedia = [];
  this.myAbortFlag = false;
  
  this.loadMediaForTeam = function( aTeamId, aCompleteCallback )
  {
    this.myCompleteCallback = aCompleteCallback;
    this.getTagsForTeam(aTeamId);
  };

  this.loadMediaForFanzone = function( aFanzoneId, aCompleteCallback )
  {
    this.myCompleteCallback = aCompleteCallback;
    this.getTagsForFanzone(aFanzoneId);
  };
  
  this.abort = function()
  {
    this.myCompleteCallback = null;
    this.myAbortFlag = true;
  }
  
  this.getTagsForTeam = function(aTeamId)
  {
    $.getJSON("/instagram_proxy/find_tags_for_team.json?team_id=" + aTeamId, 
              createDelegate(this, this.onGetTagsComplete));
  };

  this.getTagsForFanzone = function(aFanzoneId)
  {
    $.getJSON("/instagram_proxy/find_tags_for_fanzone.json?fanzone_id=" + aFanzoneId, 
              createDelegate(this, this.onGetTagsComplete));
  };
  
  this.onGetTagsComplete = function(aResult)
  {
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.myTags = aResult;
    
    if (!this.myTags || this.myTags.length == 0)
    {
      this.myCompleteCallback([]);
    }
    
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
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.myMedia = this.myMedia.concat(aResult.data);
    
    this.myMediaResponseCount++;
    if (this.myMediaResponseCount == this.myTags.length)
    {
      this.myCompleteCallback(this.myMedia);
    }
  };
}
