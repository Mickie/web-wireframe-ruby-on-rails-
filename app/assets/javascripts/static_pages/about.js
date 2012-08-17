$(function()
{
  initializeNavigation();
  addEmailAddress();
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
  trackEvent("About", "visit_about");
}

function onTeamClick(e)
{
  $(".aboutNav a").removeClass('active')
  $(e.target).addClass('active');
  $("#contactContent").hide();
  $("#aboutContent").hide();
  $("#fanzoTeamContent").slideDown(600);
  trackEvent("About", "visit_team");
}

function onContactClick(e)
{
  $(".aboutNav a").removeClass('active')
  $(e.target).addClass('active');
  $("#fanzoTeamContent").hide();
  $("#aboutContent").hide();
  $("#contactContent").slideDown(600);
  trackEvent("About", "visit_contact");
}

function addEmailAddress()
{
  coded = "ZxjHYOnz@ZmH1x.FO";
  key = "XCTltz25AmHSVqJYE4KoDG17iNFL3uBhfwepxPrc89QW6bjMkZsOyUanRv0gdI";
  shift = coded.length;
  link = "";
  for ( i = 0; i < coded.length; i++)
  {
    if (key.indexOf(coded.charAt(i)) == -1)
    {
      ltr = coded.charAt(i)
      link += (ltr)
    }
    else
    {
      ltr = (key.indexOf(coded.charAt(i)) - shift + key.length) % key.length
      link += (key.charAt(ltr))
    }
  }
  
  $("#contactContent .mailTo").html("<a href='mailto:" + link + "'>" + link + "</a>");
}
