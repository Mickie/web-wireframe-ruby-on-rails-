require 'spec_helper'

describe "comments/new" do
  before(:each) do
    @tailgate = stub_model(Tailgate, id:1)
    @post = stub_model(Post, id:1, tailgate:@tailgate)
    @comment = assign(:comment, stub_model(Comment,
      :id => 1,
      :content => "MyText",
      :user => nil,
      :post => @post
    ).as_new_record)
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tailgate_post_comments_path(@tailgate, @post, @comment), :method => "post" do
      assert_select "input#comment_content", :name => "comment[content]"
    end
  end
end
