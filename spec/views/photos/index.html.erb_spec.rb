require 'spec_helper'

describe "photos/index" do
  before(:each) do
    assign(:photos, [
      stub_model(Photo,
        :user => nil,
        :latitude => 1.6,
        :longitude => 1.5
      ),
      stub_model(Photo,
        :user => nil,
        :latitude => 1.6,
        :longitude => 1.5 
      )
    ])
  end

  it "renders a list of photos" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.6.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
