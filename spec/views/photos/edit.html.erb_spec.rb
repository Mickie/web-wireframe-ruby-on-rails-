require 'spec_helper'

describe "photos/edit" do
  before(:each) do
    @photo = assign(:photo, stub_model(Photo,
      :user => nil,
      :latitude => 1.5,
      :longitude => 1.5
    ))
  end

  it "renders the edit photo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => photos_path(@photo), :method => "post" do
      assert_select "input#photo_user", :name => "photo[user]"
      assert_select "input#photo_latitude", :name => "photo[latitude]"
      assert_select "input#photo_longitude", :name => "photo[longitude]"
    end
  end
end
