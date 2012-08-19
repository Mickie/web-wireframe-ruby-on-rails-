var InstagramView = function( aContainerDivSelector, aDialogDivSelector, aPostDivSelector )
{
  this.myContainerDiv = $(aContainerDivSelector);
  this.myDialogDiv = $(aDialogDivSelector);
  this.myPostDiv = $(aPostDivSelector);

  this.myInstagrams = {};
  this.myElements = new Array();

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
    this.myInstagramSearch.abort();
    this.myInstagramSearch = null;

    this.myInstagrams = {};
  };
  
  this.onInstagramMediaLoaded = function(anArrayOfMedia)
  {
    this.myInstagrams = anArrayOfMedia;
    $(this.myElements).each(createDelegate(this, this.createThumbnail));

    this.myDialogDiv.find("#post_image_button").click(createDelegate(this, this.onPostInstagram));
  };
  
  this.createThumbnail = function(anIndex, anElement )
  {
    if (anIndex < this.myInstagrams.length)
    {
      var theThumbnail = new InstagramThumbnail(this);
      theThumbnail.initialize( this.myInstagrams[anIndex], anElement );
    }
  };
  
  this.showImageDialog = function( anInstagram )
  {
    this.myDialogDiv.find("div.instagramImage").html("<img src='" + anInstagram.images.low_resolution.url + "' width='306' height='306'/>");
    this.myDialogDiv.find("div.instagramCaption").text(anInstagram.caption.text);
    this.myDialogDiv.find("div.modal-header h3").text(anInstagram.user.full_name);
    this.myDialogDiv.find("div.modal-header img").attr("src", anInstagram.caption.from.profile_picture);
    this.myDialogDiv.find("#post_image_button").data("instagram", anInstagram);

    $(".modal").modal("hide");
    this.myDialogDiv.modal("show");

    trackEvent("MediaSlider", "instagram_click", anInstagram.id);    
  };
  
  this.onPostInstagram = function(e)
  {
    var theInstagram = $(e.target).data("instagram");
    var theInstagramId = theInstagram.id;
    var theUrl = theInstagram.images.low_resolution.url;
    
    this.myPostDiv.find("#post_image_url").val(theUrl);
    this.myPostDiv.find("#post_video_id").val("");
    this.myPostDiv.find(".media_container").html("<img src='" + theUrl + "' width='306' height='306'/>");
    this.myPostDiv.find(".media_preview").slideDown(600);
    
    trackEvent("MediaSlider", "post_instagram", theInstagramId);    
  };
  
}
