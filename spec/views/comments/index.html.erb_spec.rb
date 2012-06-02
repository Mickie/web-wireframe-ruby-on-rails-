require 'spec_helper'

describe "comments/index" do
  before(:each) do
    @tailgate = stub_model(Tailgate, id:1)
    @user = stub_model(User)
    @post = stub_model(Post, id:1, tailgate:@tailgate)
    assign(:comments, [
      stub_model(Comment,
        :content => "MyText",
        :user => @user,
        :post => @post
      ),
      stub_model(Comment,
        :content => "MyText",
        :user => @user,
        :post => @post
      )
    ])
  end

  it "renders a list of comments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
