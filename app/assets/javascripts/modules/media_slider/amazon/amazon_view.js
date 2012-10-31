var AmazonView = function(aContainerDivSelector, 
                           aModalDivSelector, 
                           aPostDivSelector)
{
  this.myContainerDiv = $(aContainerDivSelector);
  this.myDialogDiv = $(aModalDivSelector);
  this.myPostDiv = $(aPostDivSelector);
  
  this.myAmazonProducts = null;
  this.myAmazonProductResults = {};
  this.myThumbnails = new Array();
  this.myElements = new Array();
  
  this.beginLoading = function(aTeamId)
  {
    this.myAmazonProducts = new AmazonProducts(this);
    this.myAmazonProducts.getSearchResultsForTeam(aTeamId);
  };
  
  this.cleanup = function()
  {
    if (this.myAmazonProducts)
    {
      this.myAmazonProducts.abort();
      this.myAmazonProducts = null;
    }

    this.cleanupThumbnails();

    this.myAmazonProductResults = {};
  };
  
  this.queueContainerLoad = function( anElement )
  {
    this.myElements.push( anElement );
  };
  
  this.onAmazonResultsReady = function( aJSON )
  {
    this.myAmazonProductResults = aJSON.ItemSearchResponse.Items.Item;
    
    for (var i=0, j=0; i < this.myAmazonProductResults.length && j < this.myElements.length; i++) 
    {
		try
		{
	    	theProduct = new Object();
	    	theProduct.detailUrl = this.myAmazonProductResults[i].DetailPageURL;
	    	theProduct.title = this.myAmazonProductResults[i].ItemAttributes.Title;
	    	
	    	if ( this.myAmazonProductResults[i].LargeImage )
	    	{
		    	theProduct.imageUrl = this.myAmazonProductResults[i].LargeImage.URL;
		    	theProduct.imageWidth = this.myAmazonProductResults[i].LargeImage.Width;
		    	theProduct.imageHeight = this.myAmazonProductResults[i].LargeImage.Height;
	    	}
	    	else if ( this.myAmazonProductResults[i].ImageSets.ImageSet.LargeImage )
	    	{
		    	theProduct.imageUrl = this.myAmazonProductResults[i].ImageSets.ImageSet.LargeImage.URL;
		    	theProduct.imageWidth = this.myAmazonProductResults[i].ImageSets.ImageSet.LargeImage.Width;
		    	theProduct.imageHeight = this.myAmazonProductResults[i].ImageSets.ImageSet.LargeImage.Height;
	    	}
	    	else
	    	{
		    	theProduct.imageUrl = this.myAmazonProductResults[i].ImageSets.ImageSet[0].LargeImage.URL;
		    	theProduct.imageWidth = this.myAmazonProductResults[i].ImageSets.ImageSet[0].LargeImage.Width;
		    	theProduct.imageHeight = this.myAmazonProductResults[i].ImageSets.ImageSet[0].LargeImage.Height;
	    	}
	    	
	      this.createProductThumbnail(theProduct, this.myElements[j++]);
	    }
	    catch(anError)
	    {
	      console.log("error creating amazon product thumbnail : " + anError);
	    }
	    
    };
    
    this.myDialogDiv.find("#post_media_button").click(createDelegate(this, this.onPostAmazonItem));
    this.myDialogDiv.on('hidden', createDelegate(this, this.onDialogHidden));    
  };
  
  this.onError = function(anError)
  {
    console.log(anError);
  };

  this.onSuccess = function()
  {
    
  };

  this.createProductThumbnail = function(aProduct, anElement)
  {
    var theThumbnail = new AmazonProductThumbnail(this);
    theThumbnail.initialize( aProduct, anElement );
    this.myThumbnails.push(theThumbnail);
  };  

  this.cleanupThumbnails = function()
  {
    for(var i=0,j=this.myThumbnails.length; i<j; i++)
    {
      this.myThumbnails[i].cleanup();
    };
    this.myThumbnails = new Array();
  };
  
  this.showDialog = function( aProduct )
  {
    var theTitle = "Team Gear from Amazon";
    var theAmazonIcon = "/assets/amazon-icon.png";

    var theProductInfo = "<p><a href='" + aProduct.detailUrl + "' target='blank'>" + aProduct.title + "</a></p>";
    var theProductImage = "<a href='" + aProduct.detailUrl + "' target='blank'><img src='" + aProduct.imageUrl + "'/></a>";

    this.myDialogDiv.find("div.modal-body h3").text(theTitle);
    this.myDialogDiv.find("div.modal-body img.profile_pic").attr("src", theAmazonIcon).show();
    this.myDialogDiv.find("div.mediaCaption").html(theProductInfo);
    this.myDialogDiv.find("div.mediaImage").html(theProductImage);

    this.myDialogDiv.find("#mediaImageData").show();
    this.myDialogDiv.find("#mediaVideoData").hide();

    updateTimestamps();   

    this.myDialogDiv.find("#post_media_button").data("product", aProduct).show();
    $(".modal").modal("hide");
    this.myDialogDiv.modal("show");
    
    trackEvent("MediaSlider", "Amazon_item_click", "product");    
  };
  
  this.onDialogHidden = function(e)
  {
    this.myDialogDiv.find("#post_media_button").data("product", null).hide();
  };
  
  this.onPostAmazonItem = function(e)
  {
    var theProduct = $(e.target).data("product");
    if (theProduct)
    {
      this.addAmazonProductToPost( theProduct );
      
      trackEvent("MediaSlider", "post_AmazonItem", "product");    
      $(".modal").modal("hide");
    }
  };
  
  this.addAmazonProductToPost = function( aProduct )
  {
    var theHeader = aProduct.title;
    var theBody = "\n\n" + aProduct.detailUrl;
      
    this.myPostDiv.find("#post_content").val( theHeader + theBody );
    this.myPostDiv.find("#post_image_url").val(aProduct.imageUrl);
    this.myPostDiv.find("#post_video_id").val("");
    this.myPostDiv.find(".image_container img").attr("src", aProduct.imageUrl);
    this.myPostDiv.find(".image_container").slideDown(600);
    this.myPostDiv.find(".video_container").hide();
    this.myPostDiv.find("#photo_picker").hide();
  };

}
