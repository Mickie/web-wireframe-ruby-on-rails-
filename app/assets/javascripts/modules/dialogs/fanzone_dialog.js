var FanzoneDialog = function( aDialogSelector, aNewFlag )
{
  this.myDialogSelector = aDialogSelector;
  this.myNewFlag = aNewFlag;
  this.myTeamHelper;
  
  
  this.initialize = function()
  {
    this.myTeamHelper = new TeamHelper(this.myDialogSelector + " #league_picker", this.myDialogSelector + " #tailgate_team_id");
    this.myTeamHelper.connectToLeaguePicker();
    this.initializeTopicPicker();
    this.initializeTeamPicker();
    this.initializeColorPicker();
  };
  
  this.initializeTeamPicker = function()
  {
    $(this.myDialogSelector + " #tailgate_team_id").change( createDelegate(this, this.handleTeamPicked ) );
  };
  
  this.initializeTopicPicker = function()
  {
    $(this.myDialogSelector + " #topic_data").change( createDelegate(this, this.handleTopicPicked) );
    $(this.myDialogSelector + " #tailgate_topic_tags").change( createDelegate(this, this.handleTopicChanged) );
  };
  
  this.initializeColorPicker = function()
  {
    if ($(this.myDialogSelector + " #colorPicker .color").length == 0)
    {
      return;
    } 
    
    $(this.myDialogSelector + " #colorPicker .color").each( createDelegate(this, this.setupColor) );

    this.setInitialColor();
  };
  
  this.setInitialColor = function()
  {
    if (this.myNewFlag)
    {
      var theInitialVal = $(this.myDialogSelector + " #colorPicker #tailgate_color").val();  
      $(this.myDialogSelector + " #colorPicker" + " [ data-color='" + theInitialVal + "' ]").addClass('selected');      
    }
    else
    {
      this.pickRandomColorToStart();    
    }
  };
  
  this.pickRandomColorToStart = function()
  {
    var theRandomNumber = (Math.random() + Math.random())/2.0;
    var theRandomIndex = Math.floor(theRandomNumber * $("#colorPicker .color").length);
    $($(this.myDialogSelector + " #colorPicker .color")[theRandomIndex]).click();  
  };
  
  this.setupColor = function(anIndex, anElement)
  {
    var theColor = $(anElement).data("color");
    $(anElement).css("backgroundColor", theColor);
    $(anElement).click( createDelegate(this, this.handleColorClick ) );
  };
  
  this.handleColorClick = function(e) 
  {
    $(this.myDialogSelector + " #colorPicker .selected").removeClass('selected');
    $(e.target).addClass('selected');
    $(this.myDialogSelector + " #colorPicker #tailgate_color").val($(e.target).data("color"));  
  };
  
  this.handleTeamLoaded = function( aTeam )
  {
    if ( $(this.myDialogSelector + " #tailgate_topic_tags").val().length == 0 )
    {
       $(this.myDialogSelector + " #tailgate_topic_tags").val(aTeam.social_info.hash_tags);
       $(this.myDialogSelector + " #tailgate_not_tags").val(aTeam.social_info.not_tags);
    }
  };
  
  this.handleTeamPicked = function(e)
  {
    var theId = $(e.target).val();
    $.ajax({
             url: "/teams/" + theId + ".json",
             cache:false,
             dataType: "json",
             success: createDelegate( this, this.handleTeamLoaded )
           });
  };
  
  this.handleTopicPicked = function(e)
  {
    var theCurrentChoice = $(this.myDialogSelector + " #topic_data").val();
    var theHashTags = $(this.myDialogSelector + " [ value='" + theCurrentChoice + "' ]").attr("hash_tags");
    var theNotTags = $(this.myDialogSelector + " [ value='" + theCurrentChoice + "' ]").attr("not_tags");
    $(this.myDialogSelector + " #tailgate_topic_tags").val(theHashTags);
    $(this.myDialogSelector + " #tailgate_not_tags").val(theNotTags);
  }
  
  this.handleTopicChanged = function(e)
  {
    $(this.myDialogSelector + " #tailgate_not_tags").val("");
  }
  
};