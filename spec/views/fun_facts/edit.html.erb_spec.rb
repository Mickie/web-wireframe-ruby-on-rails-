require 'spec_helper'

describe "fun_facts/edit" do
  before(:each) do
    @fun_fact = assign(:fun_fact, stub_model(FunFact,
      :name => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit fun_fact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => fun_facts_path(@fun_fact), :method => "post" do
      assert_select "input#fun_fact_name", :name => "fun_fact[name]"
      assert_select "textarea#fun_fact_content", :name => "fun_fact[content]"
    end
  end
end
