function enableFormsOnBeforeScroll(e) 
{
  var target = e.target;
  while (target.nodeType != 1) target = target.parentNode;
  
  if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA')
    e.preventDefault();
}

function scrollWindowToTopOnTouchEnd(e)
{
  window.scrollTo(0, 1);
}
