$(function()
{
  initializePositionHandler();
  initializeTopicPicker();
  initializeTeamPicker();
  initializeColorPicker();
});

var myOriginalHeight = 0;
var myOriginalWidth = 920;

function initializePositionHandler()
{
  myOriginalHeight = $("#myCreateFanzoneModal").height();
  $(window).resize( handleResize );
  handleResize();
}


function handleResize()
{
  if ($(window).height() <= myOriginalHeight )
  {
    $("#myCreateFanzoneModal").css("height", ($(window).height() - 10) + "px");
    $("#myCreateFanzoneModal").css("width", (myOriginalWidth + 15) + "px");
  }
  else
  {
    $("#myCreateFanzoneModal").css("height", "auto");
    $("#myCreateFanzoneModal").css("width", myOriginalWidth + "px");
  }

  var theWindowWidth = $(window).width();
  var theModalWidth = $("#myCreateFanzoneModal").width();
  thePosition = (theWindowWidth - theModalWidth)/2;
  $("#myCreateFanzoneModal").css("left", thePosition + "px");
  
}

function initializeTeamPicker()
{
  $("#myCreateFanzoneModal #tailgate_team_id").change(handleTeamPicked);
}

function handleTeamLoaded(aTeam)
{
  console.log(aTeam);
  
  if ( $("#myCreateFanzoneModal #tailgate_topic_tags").val().length == 0 )
  {
     $("#myCreateFanzoneModal #tailgate_topic_tags").val(aTeam.social_info.hash_tags);
     $("#myCreateFanzoneModal #tailgate_not_tags").val(aTeam.social_info.not_tags);
  }
}

function handleTeamPicked(e)
{
  var theId = $(this).val();
  $.ajax({
           url: "/teams/" + theId + ".json",
           cache:false,
           dataType: "json",
           success: handleTeamLoaded
         });
  
}

function initializeTopicPicker()
{
  $("#myCreateFanzoneModal #topic_data").change( handleTopicPicked );
  $("#myCreateFanzoneModal #tailgate_topic_tags").change( handleTopicChanged );
}

function handleTopicPicked(e)
{
  var theCurrentChoice = $("#myCreateFanzoneModal #topic_data").val();
  var theHashTags = $("#myCreateFanzoneModal [ value='" + theCurrentChoice + "' ]").attr("hash_tags");
  var theNotTags = $("#myCreateFanzoneModal [ value='" + theCurrentChoice + "' ]").attr("not_tags");
  $("#myCreateFanzoneModal #tailgate_topic_tags").val(theHashTags);
  $("#myCreateFanzoneModal #tailgate_not_tags").val(theNotTags);
}

function handleTopicChanged(e)
{
  $("#myCreateFanzoneModal #tailgate_not_tags").val("");
}

function initializeColorPicker()
{
  if ($("#colorPicker .color").length == 0)
  {
    return;
  } 
  
  $("#colorPicker .color").each(function(anIndex, anElement)
  {
    var theColor = $(anElement).data("color");
    $(anElement).css("backgroundColor", theColor);
    $(anElement).click(function(e) 
    {
      $("#colorPicker .selected").removeClass('selected');
      $(e.target).addClass('selected');
      $("#colorPicker #tailgate_color").val($(e.target).data("color"));  
    });
  });
  
  var theRandomNumber = (Math.random() + Math.random())/2.0;
  var theRandomIndex = Math.floor(theRandomNumber * $("#colorPicker .color").length);
  $($("#colorPicker .color")[theRandomIndex]).click();  
}
