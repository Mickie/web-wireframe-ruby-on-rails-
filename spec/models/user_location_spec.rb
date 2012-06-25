require 'spec_helper'

describe UserLocation do
  before do
    mock_geocoding!
    @location = FactoryGirl.create(:location)
    @user = FactoryGirl.create(:user)
    @user_location = @user.user_locations.build( location_attributes: accessible_attributes( Location, @location ) )
  end

  subject { @user_location }
  
  it { should respond_to(:location) }
  it { should respond_to(:user) }
end
