require 'spec_helper'

describe Comment do

  before do
    @comment = FactoryGirl.create(:comment)
  end

  subject { @comment }
  
  it { should respond_to(:user) }
  it { should respond_to(:content) }
  it { should respond_to(:post) }
end
