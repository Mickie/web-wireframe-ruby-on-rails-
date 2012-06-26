function onLoadDataComplete(aResult)
{
  $("#frameContent").html(aResult);
}

function onLoadError(anError)
{
  console.log(anError);  
}

function handleClick(aNewActiveSelector)
{
  $('.active').removeClass('active');
  $(aNewActiveSelector).addClass('active'); 
}

function loadData(aPath, aNewActiveSelector)
{
  handleClick(aNewActiveSelector);
  $.ajax({
           url: aPath,
           cache:false,
           dataType: "html",
           success: onLoadDataComplete,
           error: onLoadError
         });
}
