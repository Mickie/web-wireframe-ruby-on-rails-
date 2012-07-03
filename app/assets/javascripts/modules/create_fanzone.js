$(function()
{
  initializeNavigation();
  initializeTopicPicker();
  initializeTeamPicker();
  initializeColorPicker();
});

function initializeNavigation()
{
  $("#myCreateFanzoneModal .current_page").show();
  $("#myCreateFanzoneModal .page_link a").click(handleNavClick);
  $("#myCreateFanzoneModal .modal-footer a").click(handleNavClick);
}

function handleNavClick(e)
{
  $("#myCreateFanzoneModal .current_page").removeClass("current_page").slideUp(200);
  var theNewPageSelector = $(e.target).attr("href");
  $("#myCreateFanzoneModal " + theNewPageSelector ).addClass("current_page").slideDown(200);
  return false;
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
  if ($("#colorPicker").length == 0)
  {
    return;
  } 
  
  $("#colorPicker .color").each(function(anIndex, anElement)
  {
    var theColor = $(this).data("color");
    $(this).css("backgroundColor", theColor);
    $(this).click(function(e) 
    {
      $("#colorPicker .selected").removeClass('selected');
      $(e.target).addClass('selected');
      $("#colorPicker #tailgate_color").val($(e.target).data("color"));  
    });
  });
  
  var theRandomNumber = (Math.random() + Math.random())/2.0;
  var theRandomIndex = Math.floor(theRandomNumber * $("#colorPicker .color").length);
  $("#colorPicker .color")[theRandomIndex].click();  
}
