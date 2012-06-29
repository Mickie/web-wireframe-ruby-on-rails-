describe("left_nav.js", function() 
{
  describe("getIdFromHash", function()
  {
    it("should return 12 for #nav_fanzone_12", function()
    {
      var theResult = getIdFromHash("#nav_fanzone_12");
      expect(theResult).toEqual("12");
    });

    it("should return 9 for #nav_fanzone_9", function()
    {
      var theResult = getIdFromHash("#nav_fanzone_9");
      expect(theResult).toEqual("9");
    });
  });
});