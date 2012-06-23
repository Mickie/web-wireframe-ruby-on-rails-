require 'spec_helper'

describe "posts/new" do
  before(:each) do
    @tailgate = assign(:tailgate, stub_model(Tailgate,
      :name => "MyTailgate",
      :id => "1"
    ))
    assign(:post, stub_model(Post,
      :content => "MyText",
      :tailgate => @tailgate
    ).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tailgate_posts_path(@tailgate), :method => "post" do
      assert_select "textarea#post_content", :name => "post[content]"
    end
  end
end
