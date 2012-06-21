function onLoadDataComplete(aResult)
{
  $("#frameContent").html(aResult);
}

function onLoadError(anError)
{
  console.log(anError);  
}

function handleClick()
{
  $('.active').removeClass('active');
  $(this.event.target.parentNode).addClass('active'); 
}

function loadData(aPath)
{
  handleClick();
  $.ajax({
           url: aPath,
           cache:false,
           dataType: "html",
           success: onLoadDataComplete,
           error: onLoadError
         });
}
