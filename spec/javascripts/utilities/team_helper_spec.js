describe("team_helper", function() {
  var myTeamHelper;
  var THE_EXPECTED_TEAM_URL = "/teams.json?league_id=1";
  
  describe("onTeamsReady", function() {
  
    beforeEach(function() {
      myTeamHelper = new TeamHelper("div#fake_dialog");
      loadJasmineFixture('team_picker');
      
    });
  
    it("should add 2 teams as options", function() {
      myTeamHelper.onTeamsReady(TeamData.getResponse);
      expect($("select#tailgate_team_id").children().length).toEqual(2); 
    });    
  
    it("should remove existing teams when new called again", function() { 
      myTeamHelper.onTeamsReady(TeamData.getResponse);
      myTeamHelper.onTeamsReady(TeamData.getResponse);
      expect($("select#tailgate_team_id").children().length).toEqual(2); 
    });
  });


  describe("hooks league picker", function() {
  
    beforeEach(function() {
      myTeamHelper = new TeamHelper("div#fake_dialog");
      loadJasmineFixture('team_picker');

      registerFakeAjax(
      { 
        url: THE_EXPECTED_TEAM_URL,
        successData: TeamData.getResponse
      })
      
    });
  
    it("should add 2 teams as options", function() {
      myTeamHelper.connectToLeaguePicker();
      $("#league_picker").val(1).change();
      expect($("select#tailgate_team_id").children().length).toEqual(2); 
    });    
  
  });
  
});