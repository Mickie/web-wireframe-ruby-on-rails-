function enableTextAreaMaxLength()
{
  var ignore = [8, 9, 13, 33, 34, 35, 36, 37, 38, 39, 40, 46];

  $("#frameContent").on('keypress', 'textarea[maxlength]', function(event)
  {
    var self = $(this), maxlength = self.attr('maxlength'), code = $.data(this, 'keycode');
    if (maxlength && maxlength > 0)
    {
      return (self.val().length < maxlength || $.inArray(code, ignore) !== -1 );
    }
  }).on('keydown', 'textarea[maxlength]', function(event)
  {
    $.data(this, 'keycode', event.keyCode || event.which);
  });
}

$(function()
{
  enableTextAreaMaxLength();
});
