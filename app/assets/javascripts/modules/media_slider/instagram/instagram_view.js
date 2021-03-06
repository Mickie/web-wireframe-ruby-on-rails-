var InstagramView = function( aContainerDivSelector, aDialogDivSelector, aPostDivSelector )
{
  this.myContainerDiv = $(aContainerDivSelector);
  this.myDialogDiv = $(aDialogDivSelector);
  this.myPostDiv = $(aPostDivSelector);

  this.myInstagrams = {};
  this.myElements = new Array();
  this.myThumbnails = new Array();
  this.myAbortFlag = false;

  this.beginLoading = function( anArrayOfInstagramTags )
  {
    this.myInstagramSearch = new InstagramSearch(anArrayOfInstagramTags);
    this.myInstagramSearch.loadMediaForTags(createDelegate(this, this.onInstagramMediaLoaded));
  };
  
  this.queueContainerLoad = function( anElement )
  {
    this.myElements.push( anElement );
  }
  
  this.cleanup = function()
  {
    this.myAbortFlag = true;
    
    if (this.myInstagramSearch)
    {
      this.myInstagramSearch.abort();
      this.myInstagramSearch = null;
    }
    
    this.cleanupThumbnails();

    this.myInstagrams = {};
  };
  
  this.onInstagramMediaLoaded = function(anArrayOfMedia)
  {
    if (this.myAbortFlag)
    {
      return;
    }
    
    this.myInstagrams = anArrayOfMedia;
    $(this.myElements).each(createDelegate(this, this.createThumbnail));

    this.myDialogDiv.find("#post_media_button").click(createDelegate(this, this.onPostInstagram));
    this.myDialogDiv.on('hidden', createDelegate(this, this.onDialogHidden));
  };
  
  this.createThumbnail = function(anIndex, anElement )
  {
    if (anIndex < this.myInstagrams.length)
    {
      this.myThumbnails[anIndex] = new InstagramThumbnail(this);
      this.myThumbnails[anIndex].initialize( this.myInstagrams[anIndex], anElement );
    }
  };

  this.cleanupThumbnails = function()
  {
    for(var i=0,j=this.myThumbnails.length; i<j; i++)
    {
      this.myThumbnails[i].cleanup();
    };
    this.myThumbnails = new Array();
  }
  
  this.showDialog = function( anInstagram )
  {
    var theProfileImage = makeUrlHttpsSafe(anInstagram.caption.from.profile_picture);
    var theBigImage = makeUrlHttpsSafe(anInstagram.images.standard_resolution.url);    
    
    this.myDialogDiv.find("div.mediaImage").html("<img src='" + theBigImage + "'/>");
    this.myDialogDiv.find("div.mediaCaption").text(anInstagram.caption.text);
    this.myDialogDiv.find("div.modal-body h3").text(anInstagram.user.full_name);
    this.myDialogDiv.find("div.modal-body img.profile_pic").attr("src", theProfileImage).show();
    this.myDialogDiv.find("#post_media_button").data("instagram", anInstagram).show();

    this.myDialogDiv.find("#mediaImageData").show();
    this.myDialogDiv.find("#mediaVideoData").hide();

    $(".modal").modal("hide");
    this.myDialogDiv.modal("show");

    trackEvent("MediaSlider", "instagram_click", anInstagram.id);    
  };
  
  this.onDialogHidden = function(e)
  {
    this.myDialogDiv.find("#post_media_button").data("instagram", null).hide();
  }
  
  this.onPostInstagram = function(e)
  {
    var theInstagram = $(e.target).data("instagram");
    if (theInstagram)
    {
      var theInstagramId = theInstagram.id;
      var theUrl = theInstagram.images.low_resolution.url;
      
      this.myPostDiv.find("#post_image_url").val(theUrl);
      this.myPostDiv.find("#post_video_id").val("");
      this.myPostDiv.find(".image_container img").attr("src", theUrl);
      this.myPostDiv.find(".image_container").slideDown(600);
      this.myPostDiv.find(".video_container").hide();
      this.myPostDiv.find("#photo_picker").hide();
      
      trackEvent("MediaSlider", "post_instagram", theInstagramId);    
      $(".modal").modal("hide");
    }
  };
  
}
