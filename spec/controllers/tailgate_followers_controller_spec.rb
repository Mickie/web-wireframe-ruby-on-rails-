require 'spec_helper'

describe TailgateFollowersController do
  login_user

  let(:tailgate) { FactoryGirl.create(:tailgate) }

  before { mock_geocoding! }

  describe "creating a tailgate_follower with Ajax" do

    it "should increment the TailgateFollower count" do
      expect {
        xhr :post, :create, tailgate_follower: { tailgate_id: tailgate.id }
      }.to change(TailgateFollower, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, tailgate_follower: { tailgate_id: tailgate.id }
      response.should be_success
    end
  end

  describe "destroying a tailgate_follower with Ajax" do

    before { subject.current_user.follow!( tailgate ) }
    let(:tailgate_follower) { subject.current_user.tailgate_followers.find_by_tailgate_id(tailgate.id) }

    it "should decrement the tailgate_follower count" do
      expect {
        xhr :delete, :destroy, id: tailgate_follower.id
      }.to change(TailgateFollower, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: tailgate_follower.id
      response.should be_success
    end
  end
end