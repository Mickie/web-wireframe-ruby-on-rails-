require 'spec_helper'

describe "events/edit" do
  before(:each) do
    mock_geocoding!
    
    @home_team = FactoryGirl.create(:team)
    @visiting_team = FactoryGirl.create(:team)
    theStub = stub_model(Event,
      :name => "MyString",
      :home_team => @home_team,
      :visiting_team => @visiting_team,
      :location => nil
    )
    theStub.build_location
    
    @event = assign(:event, theStub)
  end

  it "renders the edit event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => events_path(@event), :method => "post" do
      assert_select "input#event_name", :name => "event[name]"

      assert_select "select#event_home_team_id", :name => "event[home_team_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#event_visiting_team_id", :name => "event[visiting_team_id]" do
        assert_select "option[selected]"
      end

      assert_select "input#event_location_attributes_name", :name => "event[location_attributes][name]"
      assert_select "input#event_location_attributes_address1", :name => "event[location_attributes][address1]"
      assert_select "input#event_location_attributes_address2", :name => "event[location_attributes][address2]"
      assert_select "input#event_location_attributes_city", :name => "event[location_attributes][city]"
      assert_select "input#event_location_attributes_postal_code", :name => "event[location_attributes][postal_code]"
      assert_select "select#event_location_attributes_state_id", :name => "event[location_attributes][state_id]"
      assert_select "select#event_location_attributes_country_id", :name => "event[location_attributes][country_id]"
    end
  end
end
