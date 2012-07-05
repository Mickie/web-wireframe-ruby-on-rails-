require 'spec_helper'

describe InstagramProxyController do
  
  before do
    mock_geocoding!
    @myTeam = FactoryGirl.create(:team)

    @theClientDouble = double(Instagram::Client)
    Instagram.stub(:client).and_return(@theClientDouble)
  end
  
  
  describe "GET 'find_tags_for_team' responds to JSON request" do
    before do
      theListOfTags = [ Hashie::Mash.new({media_count:2108,name:"nd"}), Hashie::Mash.new({media_count:492,name:"goirish"}) ]
      @theClientDouble.stub(:tag_search).and_return(theListOfTags)
        
      get 'find_tags_for_team', team_id:@myTeam.id, format: :json
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
  
  describe "mergeTags" do
    let(:theFirstTagArray) { [ Hashie::Mash.new({media_count:100}),  Hashie::Mash.new({media_count:150}) ] }
    
    it "merges smaller value correctly" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 80}), Hashie::Mash.new({media_count: 120}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(100)
      theResult[1].media_count.should eq(80)
      theResult[2].media_count.should eq(150)
      theResult[3].media_count.should eq(120)
    end

    it "merges larger value correctly" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 120}), Hashie::Mash.new({media_count: 180}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(120)
      theResult[1].media_count.should eq(100)
      theResult[2].media_count.should eq(180)
      theResult[3].media_count.should eq(150)
    end

    it "merges mixed values correctly" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 120}), Hashie::Mash.new({media_count: 70}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(120)
      theResult[1].media_count.should eq(100)
      theResult[2].media_count.should eq(150)
      theResult[3].media_count.should eq(70)
    end

    it "handles shorter arrays" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 80}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(100)
      theResult[1].media_count.should eq(80)
      theResult[2].media_count.should eq(150)
    end

    it "handles longer arrays" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 80}), Hashie::Mash.new({media_count: 120}), Hashie::Mash.new({media_count: 90}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(100)
      theResult[1].media_count.should eq(80)
      theResult[2].media_count.should eq(150)
      theResult[3].media_count.should eq(120)
      theResult[4].media_count.should eq(90)
    end

    describe "with three tags" do
      let( :theSecondTagArray ) { [ Hashie::Mash.new({media_count: 60}) ] }

      it "when smaller" do
        theThirdTagArray = [ Hashie::Mash.new({media_count: 40}) ]
        theResult = subject.mergeTags([theFirstTagArray, theSecondTagArray, theThirdTagArray])
        theResult[0].media_count.should eq(100)
        theResult[1].media_count.should eq(60)
        theResult[2].media_count.should eq(40)
        theResult[3].media_count.should eq(150)
      end

      it "when larger" do
        theThirdTagArray = [ Hashie::Mash.new({media_count: 80}) ]
        theResult = subject.mergeTags([theFirstTagArray, theSecondTagArray, theThirdTagArray])
        theResult[0].media_count.should eq(100)
        theResult[1].media_count.should eq(80)
        theResult[2].media_count.should eq(60)
        theResult[3].media_count.should eq(150)
      end

      it "when largest" do
        theThirdTagArray = [ Hashie::Mash.new({media_count: 120}) ]
        theResult = subject.mergeTags([theFirstTagArray, theSecondTagArray, theThirdTagArray])
        theResult[0].media_count.should eq(120)
        theResult[1].media_count.should eq(100)
        theResult[2].media_count.should eq(60)
        theResult[3].media_count.should eq(150)
      end
    end

    describe "different size arrays" do
      it "should handle long middle array" do
        theSecondTagArray = [ Hashie::Mash.new({media_count: 140}), Hashie::Mash.new({media_count: 60}), Hashie::Mash.new({media_count: 90}) ]
        theThirdTagArray = [ Hashie::Mash.new({media_count: 80}), Hashie::Mash.new({media_count: 160}) ]
        theResult = subject.mergeTags([theFirstTagArray, theSecondTagArray, theThirdTagArray])
        theResult[0].media_count.should eq(140)
        theResult[1].media_count.should eq(100)
        theResult[2].media_count.should eq(80)
        theResult[3].media_count.should eq(160)
        theResult[4].media_count.should eq(150)
        theResult[5].media_count.should eq(60)
        theResult[6].media_count.should eq(90)
      end
    end


  end
end
