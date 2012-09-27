var FirstRunWizard = function()
{
  this.myDialogSelector;
  
  this.initialize = function(aDialogSelector)
  {
    this.myDialogSelector = aDialogSelector;
    $(this.myDialogSelector).modal({ backdrop: "static", keyboard: false, show: true});
  }
}

var mySingleFirstRunWizard = new FirstRunWizard();

FirstRunWizard.get = function()
{
  return mySingleFirstRunWizard;
}
