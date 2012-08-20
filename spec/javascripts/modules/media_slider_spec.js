describe("MediaSlider", function() 
{
  var myMediaSlider; 

  beforeEach(function()
  {
    myMediaSlider = new MediaSliderNew("div#myMediaSlider", 
                                        "div#myVideoModal",
                                        "div#myImageModal",
                                        "div#postForm");

    loadJasmineFixture('media_slider');
  });
  
});