require 'spec_helper'

describe InstagramProxyController do
  
  describe "InstagramProxuController" do
    
    before do
      mock_geocoding!
      @myTeam = FactoryGirl.create(:team)

      @theClientDouble = double(Instagram::Client)
      Instagram.stub(:client).and_return(@theClientDouble)
    end
    
    
    describe "GET 'find_tags' responds to JSON request" do
      before do
        theListOfTags = [ Hashie::Mash.new({media_count:2108,name:"nd"}), Hashie::Mash.new({media_count:492,name:"goirish"}) ]
        @theClientDouble.stub(:tag_search).and_return(theListOfTags)
          
        get 'find_tags', team_id:@myTeam.id, format: :json
      end
      
      it "returns http success" do
        response.status.should be(200)
        response.should be_success
      end

      it "returns a list of tags for a team" do
        theResult = JSON.parse(response.body)
        theResult.length.should eq(2)
        theResult[0]["media_count"].should eq(2108)
      end
    end
  
    describe "GET 'media_for_tag' responds to JSON request" do
      
      before do
        theMedia = ["media"]
        @theClientDouble.stub(:tag_recent_media).and_return(theMedia)
        
        get 'media_for_tag', tag: "foo", format: :json
      end
      
      it "returns http success" do
        response.status.should be(200)
        response.should be_success
      end
    end
  end
end
