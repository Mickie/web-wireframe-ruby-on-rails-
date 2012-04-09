require 'spec_helper'

describe Location do
  before do
    @location = FactoryGirl.create(:location)
  end

  describe "handles basic methods" do
    subject { @location }
    
    it { should respond_to(:name) }
    it { should respond_to(:address1) }
    it { should respond_to(:address2) }
    it { should respond_to(:city) }
    it { should respond_to(:state) }
    it { should respond_to(:postal_code) }
    it { should respond_to(:country) }
    it { should respond_to(:latitude) }
    it { should respond_to(:longitude) } 
    it { should respond_to(:one_line_address) }
  end
  
  describe "one_line_address" do
  
    it "should return correctly formatted address" do
      @location.one_line_address.should == "12 Seahawks Way, Renton, WA 98056"
    end
    
  end  
  
  describe "one_line_address_changed?" do

    it "should return false when no element changes" do
      @location.one_line_address_changed?.should be_false
    end

    it "should return true when no element changes" do
      @location.city = "Bellevue"
      @location.one_line_address_changed?.should be_true
    end
    
  end
end
