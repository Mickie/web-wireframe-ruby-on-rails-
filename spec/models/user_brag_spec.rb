require 'spec_helper'

describe UserBrag do
  before do
    @user = FactoryGirl.create(:user)
    @brag = FactoryGirl.create(:brag)
    @user_brag = UserBrag.new( brag_id: @brag.id)
    @user_brag.user_id = @user.id
  end

  subject { @user_brag }
  
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:brag_id) }
  it { should respond_to(:brag) }
  it { should respond_to(:type) }
end
