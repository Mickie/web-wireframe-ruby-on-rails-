$(function()
{
  function getParent($this) {
    var selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = $(selector)
    $parent.length || ($parent = $this.parent())

    return $parent
  }
    
  $.fn.dropdown.Constructor.prototype.toggle = function(e)
  {
    var $this = $(this)
      , $parent
      , isActive

    if ($this.is('.disabled, :disabled')) return

    $parent = getParent($this)

    isActive = $parent.hasClass('open')

    $parent.removeClass('open');
      
    if (!isActive) {
      $parent.toggleClass('open')
      $this.focus()
    }

    return false
  }
})
