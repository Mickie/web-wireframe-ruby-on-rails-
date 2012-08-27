var FanzoneView = function()
{
  this.myTailgateModel = {};
  
  this.loadTailgate = function( aPath )
  {
    var thePath = aPath + ".json";
    this.loadTailgateIntoFanzoneView( thePath );
  }
  
  this.loadTailgateIntoFanzoneView = function( aPath )
  {
    var theToken = $('meta[name=csrf-token]').attr('content');
    $.ajax({
             url: aPath + "?authenticity_token=" + theToken,
             cache:false,
             dataType: "json",
             success: createDelegate(this, this.onTailgateLoadComplete ),
             error: createDelegate(this, this.onLoadError )
           });
  }

  this.onTailgateLoadComplete = function( aResult )
  {
    this.myTailgateModel = aResult;
    console.log(this.myTailgateModel);
    
    $("#phoneFanzoneContent").render(this.myTailgateModel, this.getFanzoneDirective());
    updateTimestamps();
  };

  this.onLoadError = function(anError)
  {
    console.log(anError);  
  };
  
  this.getFanzoneDirective = function()
  {
    var theThis = this;
    return {
      ".team_logo img@src" : function(anItem)
      {
        var theSlug = anItem.context.team.slug;
        return "http://fanzo_static.s3.amazonaws.com/logos/" + theSlug + "_m.gif";
      },
      ".official@style": function(anItem)
      {
        return anItem.context.official ? "display:block" : "display:none";
      },
      ".banner_content@style": function(anItem)
      {
        return "background-color:" + anItem.context.color;
      },
      ".fanzoneName": "name",
      ".description" : "description",
      ".profile_pic img@src" : "user.image",
      ".owner_name" : "user.first_name",
      ".timestamp@title" : "created_at",
      ".timestamp" : "created_at"
    }
  };
  
  
}
