require 'spec_helper'

describe UserLocation do
  before do
    mock_geocoding!
    @location = FactoryGirl.create(:location)
    @user = FactoryGirl.create(:user)
    @user_location = UserLocation.new(user:@user, location:@location)
  end

  subject { @user_location }
  
  it { should respond_to(:location) }
  it { should respond_to(:user) }
end
