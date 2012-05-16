describe("globals", function() {
  
  describe("createDelegate", function() {
    var theCalledMethodFlag = false;
    var theObject = new Object();
    var theResult;
  
    beforeEach(function() {
      theObject.method = function() { theCalledMethodFlag = true; };
      theResult = createDelegate(theObject, theObject.method)
    });
  
  
    it("should return a function", function() {
      expect( typeof theResult === 'function').toBeTruthy();
    });    
  
    it("should be connected to the correct object", function() {
      theResult();
      expect( theCalledMethodFlag ).toBeTruthy();
    });
  
  });
  
  describe("createExtendedDelegate", function() {
    var theCalledMethodFlag = false;
    var theArgumentPassed;
    var theObject = new Object();
    var theResult;
  
    beforeEach(function() {
      theObject.method = function( anArgument ) { theCalledMethodFlag = true; theArgumentPassed = anArgument };
      theResult = createExtendedDelegate(theObject, theObject.method, ['expected'])
    });
  
    it("should return a function", function() {
      expect( typeof theResult === 'function').toBeTruthy();
    });    
  
    it("should be connected to the correct object", function() {
      theResult();
      expect( theCalledMethodFlag ).toBeTruthy();
    });
  
    it("should pass the expected argument to the function", function() {
      theResult();
      expect( theArgumentPassed ).toEqual('expected');
    });
  
  });
  
});