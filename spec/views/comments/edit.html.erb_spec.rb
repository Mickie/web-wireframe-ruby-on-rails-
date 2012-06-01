require 'spec_helper'

describe "comments/edit" do
  before(:each) do
    @comment = assign(:comment, stub_model(Comment,
      :content => "MyText",
      :user => nil,
      :post => nil
    ))
  end

  it "renders the edit comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path(@comment), :method => "post" do
      assert_select "textarea#comment_content", :name => "comment[content]"
      assert_select "input#comment_user", :name => "comment[user]"
      assert_select "input#comment_post", :name => "comment[post]"
    end
  end
end
