require 'spec_helper'

describe "brags/edit" do
  before(:each) do
    @brag = assign(:brag, stub_model(Brag,
      :content => "MyString"
    ))
  end

  it "renders the edit brag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => brags_path(@brag), :method => "post" do
      assert_select "input#brag_content", :name => "brag[content]"
    end
  end
end
