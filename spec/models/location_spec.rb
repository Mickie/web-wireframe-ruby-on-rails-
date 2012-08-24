require 'spec_helper'

describe Location do
  before do
    mock_geocoding!
    @location = FactoryGirl.create(:location)
  end

  describe "handles basic methods" do
    subject { @location }
    
    it { should respond_to(:name) }
    it { should respond_to(:address1) }
    it { should respond_to(:address2) }
    it { should respond_to(:city) }
    it { should respond_to(:state) }
    it { should respond_to(:region) }
    it { should respond_to(:postal_code) }
    it { should respond_to(:country) }
    it { should respond_to(:latitude) }
    it { should respond_to(:longitude) } 
    it { should respond_to(:one_line_address) }
    it { should respond_to(:stateNameOrRegion) }
  end
  
  describe "stateNameOrRegion" do
    
    it "should return state name when available" do
      @location.stateNameOrRegion.should eq(@location.state.name)
    end
    
    it "should return region if no state" do
      @location.state_id = nil
      @location.region = "test"
      @location.stateNameOrRegion.should eq("test")
    end
    
  end
  
  describe "one_line_address" do
  
    it "should return correctly formatted address" do
      @location.one_line_address.should == "12 Seahawks Way, Renton, WA 98056, US"
    end
    
    it "should handle empty string in address2" do
      @location.address2 = "Go Hawks"
      @location.one_line_address.should == "12 Seahawks Way, Go Hawks, Renton, WA 98056, US"
    end
    
    it "should handle international addresses" do
      theCountry = Country.find_by_name("United Kingdom")
      theInternationalLocation = Location.new(name:"Emirates Stadium",
                                              address1: "75 Drayton Park",
                                              city: "London",
                                              region: "Greater London",
                                              postal_code:"N5 1BU",
                                              country_id: theCountry.id)
      theInternationalLocation.one_line_address.should == "75 Drayton Park, London, Greater London N5 1BU, UK"
    end
    
  end  
  
  describe "one_line_address_changed?" do

    it "should return false when no element changes" do
      @location.one_line_address_changed?.should be_false
    end

    it "should return true when an element changes" do
      @location.city = "Bellevue"
      @location.one_line_address_changed?.should be_true
    end

    it "should return true when region changes" do
      @location.region = "Northwest"
      @location.one_line_address_changed?.should be_true
    end

    it "should return true when country changes" do
      @location.country_id = 7
      @location.one_line_address_changed?.should be_true
    end

    it "should handle null state" do
      @location.state_id = nil
      @location.one_line_address_changed?.should be_true
      @location.save
      @location.one_line_address_changed?.should be_false
      @location.region = "Northwest"
      @location.one_line_address_changed?.should be_true
    end

    
    
  end
  
  describe "isSimilarAddress?" do
    before do
      @location.address1 = '1864 W Lk St.'
      @location.postal_code = '86457'
    end
    
    it "should be false if zips don't match" do
      @location.isSimilarAddress?('1864 W Lk St.', '76092').should be_false
    end

    it "should be false if house numbers don't match" do
      @location.isSimilarAddress?('1234 N 168th Ave', '86457').should be_false      
    end
    
    it "should be true if zip matches and address1 is close" do
      @location.isSimilarAddress?('1864 W Lk St.', '86457').should be_true
      @location.isSimilarAddress?('1864 West Lk St.', '86457').should be_true
      @location.isSimilarAddress?('1864 W Lake St.', '86457').should be_true
      @location.isSimilarAddress?('1864 W Lake ST', '86457').should be_true
    end
    
    it "works with harder matches" do
      @location.address1 = 'One Legends Way'

      @location.isSimilarAddress?('1 Legends Way', '86457').should be_true
      @location.isSimilarAddress?('One Legends Wy', '86457').should be_true

    end
  end
end
