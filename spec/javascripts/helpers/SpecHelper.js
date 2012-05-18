beforeEach(function() {
  this.addMatchers({
    toBePlaying: function(expectedSong) {
      var player = this.actual;
      return player.currentlyPlayingSong === expectedSong
          && player.isPlaying;
    }
  })
});

function loadJasmineFixture(aFixture)
{
  useRealAjaxFor({url:'jasmine/fixtures/' + aFixture});
  jasmine.getFixtures().fixturesPath = 'jasmine/fixtures';
  loadFixtures( aFixture );
}
