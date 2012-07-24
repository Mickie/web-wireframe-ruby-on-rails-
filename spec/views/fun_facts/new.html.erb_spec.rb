require 'spec_helper'

describe "fun_facts/new" do
  before(:each) do
    assign(:fun_fact, stub_model(FunFact,
      :name => "MyString",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new fun_fact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => fun_facts_path, :method => "post" do
      assert_select "input#fun_fact_name", :name => "fun_fact[name]"
      assert_select "textarea#fun_fact_content", :name => "fun_fact[content]"
    end
  end
end
