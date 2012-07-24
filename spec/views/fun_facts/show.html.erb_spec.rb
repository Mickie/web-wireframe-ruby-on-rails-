require 'spec_helper'

describe "fun_facts/show" do
  before(:each) do
    @fun_fact = assign(:fun_fact, stub_model(FunFact,
      :name => "Name",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
  end
end
