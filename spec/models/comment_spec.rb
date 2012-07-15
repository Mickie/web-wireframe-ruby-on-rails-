require 'spec_helper'

describe Comment do

  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate)
    @post = @tailgate.posts.create(user_id:@tailgate.user.id, content: "content")
    @comment = @post.comments.create(user_id: @tailgate.user.id)
  end

  subject { @comment }

  it { should respond_to(:fan_score) }  
  it { should respond_to(:user) }
  it { should respond_to(:content) }
  it { should respond_to(:post) }
  
  it "should be visible if fan_score is greater than -3" do
    Comment.visible.first.should eq(@comment)
  end

  it "should be not visible if fan_score is less or equal to -3" do
    @comment.fan_score = -3;
    @comment.save
    Comment.visible.size.should eq(0)
  end
end
