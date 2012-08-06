require 'spec_helper'

describe "brags/new" do
  before(:each) do
    assign(:brag, stub_model(Brag,
      :content => "MyString"
    ).as_new_record)
  end

  it "renders new brag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => brags_path, :method => "post" do
      assert_select "input#brag_content", :name => "brag[content]"
    end
  end
end
