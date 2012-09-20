var EventManager = function()
{
  this.myObservers = {};

  this.addObserver = function( aNotification, anObserver )
  {
    if (!this.myObservers[aNotification])
    {
      this.myObservers[aNotification] = new Array();
    }
    this.myObservers[aNotification].push(anObserver);
  }
  
  this.notifyObservers = function(aNotification, anArgumentsArray)
  {
    for(var i=0,j=this.myObservers[aNotification].length; i<j; i++)
    {
      this.myObservers[aNotification][i][aNotification].apply(this.myObservers[aNotification][i], anArgumentsArray);
    };
  }
}

var myEventManager = new EventManager();
EventManager.get = function()
{
  return myEventManager;
}

