$(function()
{
  initializeColorPicker();
});

function initializeColorPicker()
{
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
  
  var theRandomIndex = Math.floor(Math.random() * $("#colorPicker .color").length);
  $("#colorPicker .color")[theRandomIndex].click();  
}
