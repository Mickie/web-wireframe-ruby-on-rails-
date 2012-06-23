require 'spec_helper'

describe "posts/index" do
  before(:each) do
    @tailgate = assign(:tailgate, stub_model(Tailgate,
      :name => "MyTailgate",
      :id => "1"
    ))
    assign(:posts, [
      stub_model(Post,
        :content => "MyText",
        :tailgate => @tailgate
      ),
      stub_model(Post,
        :content => "MyText",
        :tailgate => @tailgate
      )
    ])
  end

  it "renders a list of posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
