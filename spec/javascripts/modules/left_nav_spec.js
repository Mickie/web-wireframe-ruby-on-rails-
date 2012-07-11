describe("left_nav.js", function() 
{
  describe("getIdFromHash", function()
  {
    it("should return 12 for #nav_12", function()
    {
      var theResult = getIdFromHash("#nav_12");
      expect(theResult).toEqual("12");
    });

    it("should return 9 for #nav_9", function()
    {
      var theResult = getIdFromHash("#nav_9");
      expect(theResult).toEqual("9");
    });

    it("should return irish-white-knucklers for #nav_irish-white-knucklers", function()
    {
      var theResult = getIdFromHash("#nav_irish-white-knucklers");
      expect(theResult).toEqual("irish-white-knucklers");
    });
  });
});