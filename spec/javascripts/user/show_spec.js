describe("user_show", function() {
  
  describe("onTeamsReady", function() {
  
    beforeEach(function() {
      loadJasmineFixture('show');
      onTeamsReady(TeamData.getResponse);
    });
  
  
    it("should add 2 teams as options", function() {
      expect($("select#user_team_team_id").children().length).toEqual(2); 
    });    
  
    it("should remove existing teams when new called again", function() { 
      onTeamsReady(TeamData.getResponse);
      expect($("select#user_team_team_id").children().length).toEqual(2); 
    });
  
  });
});