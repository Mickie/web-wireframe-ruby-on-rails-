require 'spec_helper'

describe "Posts" do
  
  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate) 
  end
  
  describe "GET /tailgates/1/posts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tailgate_posts_path(@tailgate)
      response.status.should be(200)
    end
  end
end
