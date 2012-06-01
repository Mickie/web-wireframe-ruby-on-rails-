require 'spec_helper'

describe "posts/show" do
  before(:each) do
    @tailgate = assign(:tailgate, stub_model(Tailgate,
      :name => "MyTailgate",
      :id => "1"
    ))
    @post = assign(:post, stub_model(Post,
      :title => "MyString",
      :content => "MyText",
      :tailgate_id => @tailgate.id
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
  end
end
