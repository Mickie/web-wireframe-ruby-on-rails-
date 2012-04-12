require 'spec_helper'

describe VenueType do

  before do
    @venue_type = FactoryGirl.create(:venue_type)
  end

  subject { @venue_type }
  
  it { should respond_to(:name) }
  it { should respond_to(:venues) }

end
