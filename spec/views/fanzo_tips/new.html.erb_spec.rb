require 'spec_helper'

describe "fanzo_tips/new" do
  before(:each) do
    assign(:fanzo_tip, stub_model(FanzoTip,
      :name => "MyString",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new fanzo_tip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => fanzo_tips_path, :method => "post" do
      assert_select "input#fanzo_tip_name", :name => "fanzo_tip[name]"
      assert_select "textarea#fanzo_tip_content", :name => "fanzo_tip[content]"
    end
  end
end
