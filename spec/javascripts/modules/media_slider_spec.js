describe("MediaSlider", function() 
{
  var myMediaSlider; 

  beforeEach(function()
  {
    myMediaSlider = new MediaSliderNew("div#myMediaSlider", 
                                        "div#myMediaModal",
                                        "div#myMediaModal",
                                        "div#postForm");

    loadJasmineFixture('media_slider');
  });
  
});