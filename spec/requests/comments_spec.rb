require 'spec_helper'

describe "Comments" do
  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate) 
    @post = FactoryGirl.create(:post, tailgate:@tailgate, user:@tailgate.user)
  end

  describe "GET /comments" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tailgate_post_comments_path(@tailgate, @post)
      response.status.should be(200)
    end
  end
end
