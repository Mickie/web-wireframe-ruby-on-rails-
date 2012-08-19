describe("MediaSlider", function() 
{
  var myMediaSlider; 

  beforeEach(function()
  {
    myMediaSlider = new MediaSliderNew("div#myMediaSlider", 
                                        "div#myVideoModal",
                                        "div#myInstagramModal",
                                        "div#postForm");

    loadJasmineFixture('media_slider');
  });
  
});