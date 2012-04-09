require 'spec_helper'

describe Location do
  before do
    @location = FactoryGirl.create(:location)
  end

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
end
