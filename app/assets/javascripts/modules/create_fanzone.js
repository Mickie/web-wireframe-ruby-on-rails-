$(function()
{
  initializeColorPicker();
});

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
