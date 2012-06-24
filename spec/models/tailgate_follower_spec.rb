require 'spec_helper'

describe TailgateFollower do
  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate)
    @user = FactoryGirl.create(:user)
    @tailgate_follower = @user.tailgate_followers.build(tailgate_id: @tailgate.id)
  end

  subject { @tailgate_follower }
  
  it { should be_valid }
  
  describe "follower methods" do    
    it { should respond_to(:tailgate) }
    it { should respond_to(:user) }
    its(:tailgate) { should == @tailgate }
    its(:user) { should == @user }
  end
    
  describe "when user id is not present" do
    before { @tailgate_follower.user_id = nil }
    it { should_not be_valid }
  end

  describe "when tailgate id is not present" do
    before { @tailgate_follower.tailgate_id = nil }
    it { should_not be_valid }
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        TailgateFollower.new(user_id: @user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end  
end
