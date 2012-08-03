require 'spec_helper'

describe UserLocation do
  before do
    @user = FactoryGirl.create(:user)
    @user_location = @user.user_locations.build( location_query:"Seattle, WA" )
  end

  subject { @user_location }
  
  it { should respond_to(:location_query) }
  it { should respond_to(:user) }
end
