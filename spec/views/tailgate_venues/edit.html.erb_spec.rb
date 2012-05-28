require 'spec_helper'

describe "tailgate_venues/edit" do
  before(:each) do
    @theVenue = stub_model(Venue, name:"joes", id:1)
    @theTailgate = stub_model(Tailgate, name:"party", id:1)
    @tailgate_venue = assign(:tailgate_venue, stub_model(TailgateVenue,
      :tailgate => @theTailgate,
      :venue => @theVenue,
      :latitude => 1.5,
      :longitude => 1.5
    ))
  end

  it "renders the edit tailgate_venue form" do
    Venue.should_receive(:order).at_least(1).times.and_return(Venue)
    Venue.should_receive(:all).at_least(1).times.and_return([@theVenue])
    
    Tailgate.should_receive(:order).at_least(1).times.and_return(Tailgate)
    Tailgate.should_receive(:all).at_least(1).times.and_return([@theTailgate])
    
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tailgate_venues_path(@tailgate_venue), :method => "post" do
      assert_select "select#tailgate_venue_venue_id", :name => "tailgate_venue[venue_id]" do
        assert_select "option[selected]"
      end
      assert_select "select#tailgate_venue_tailgate_id", :name => "tailgate_venue[tailgate_id]" do
        assert_select "option[selected]"
      end

    end
  end
end
