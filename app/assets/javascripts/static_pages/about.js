$(function(){
  initializeNavigation();
});

function initializeNavigation()
{
  $("a#about").click(onAboutClick);
  $("a#team").click(onTeamClick);
  $("a#contact").click(onContactClick);
}

function onAboutClick(e)
{
  $(".aboutNav a").removeClass('active')
  $(e.target).addClass('active');
  $("#fanzoTeamContent").hide();
  $("#contactContent").hide();
  $("#aboutContent").slideDown(600);
}

function onTeamClick(e)
{
  $(".aboutNav a").removeClass('active')
  $(e.target).addClass('active');
  $("#contactContent").hide();
  $("#aboutContent").hide();
  $("#fanzoTeamContent").slideDown(600);
}

function onContactClick(e)
{
  $(".aboutNav a").removeClass('active')
  $(e.target).addClass('active');
  $("#fanzoTeamContent").hide();
  $("#aboutContent").hide();
  $("#contactContent").slideDown(600);
}
