require 'spec_helper'

describe "comments/show" do
  before(:each) do
    @tailgate = stub_model(Tailgate, id:1)
    @post = stub_model(Post, id:1, tailgate:@tailgate)
    @comment = assign(:comment, stub_model(Comment,
      :id => 1,
      :content => "MyText",
      :user => nil,
      :post => @post
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(//)
    rendered.should match(//)
  end
end
