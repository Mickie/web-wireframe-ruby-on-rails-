require 'spec_helper'

describe UserBrag do
  before do
    @user = FactoryGirl.create(:user)
    @brag = FactoryGirl.create(:brag)
    @user_brag = @user.user_brags.build( brag_id: @brag.id, type:1 )
  end

  subject { @user_brag }
  
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:brag_id) }
  it { should respond_to(:brag) }
  it { should respond_to(:type) }
end
