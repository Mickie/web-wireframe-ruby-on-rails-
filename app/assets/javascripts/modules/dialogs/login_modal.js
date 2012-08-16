$(function()
{
  $("#myLoginModal .showExplanation").click( onShowExplanationClick );
  $("#myLoginModal .showOnlyFacebook").click( onShowOnlyFacebook );
  $("#myLoginModal .showUseFacebook").click( onShowUseFacebook );

  $("#myLoginModal #facebook-login-button").click( onLogin );
});

function onShowExplanationClick(e)
{
  $("#myLoginModal .whyFacebook").fadeOut(300);
  $("#myLoginModal .explanation").slideDown(600, onAnimationComplete);
  trackEvent("Login", "show_explanation");
};

function onShowOnlyFacebook(e)
{
  $("#myLoginModal .onlyFacebook").fadeIn(600, onAnimationComplete);
  $("#myLoginModal .showOnlyFacebook").addClass("active");
  
  $("#myLoginModal .useFacebook").hide();
  $("#myLoginModal .showUseFacebook").removeClass("active");

  trackEvent("Login", "show_only_facebook");
};

function onShowUseFacebook(e)
{
  $("#myLoginModal .useFacebook").fadeIn(600, onAnimationComplete);
  $("#myLoginModal .showUseFacebook").addClass("active");

  $("#myLoginModal .onlyFacebook").hide();
  $("#myLoginModal .showOnlyFacebook").removeClass("active");

  trackEvent("Login", "show_use_facebook");
};

function onLogin(e)
{
  trackEvent("Login", "login_clicked");
}

function onAnimationComplete(e)
{
  myDialogResizer.refreshDimensions();
};
