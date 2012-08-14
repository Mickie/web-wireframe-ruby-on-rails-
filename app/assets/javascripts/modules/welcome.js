$(function(){
  showWelcomeIfNewUser();
})

function showWelcomeIfNewUser()
{
  var theVisitedCookie = getCookie("fanzo-visited");
  
  if(!theVisitedCookie)
  {
    $("#welcome").slideDown(600);
  }

  setCookie("fanzo-visited", "true", 365);
}
