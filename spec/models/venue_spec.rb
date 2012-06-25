require 'spec_helper'

describe Venue do

  before do
    mock_geocoding!
    @venue = FactoryGirl.create(:venue)
  end

  subject { @venue }
  
  it { should respond_to(:name) }
  it { should respond_to(:venue_type) }
  it { should respond_to(:location) }
  it { should respond_to(:social_info) }
  it { should respond_to(:game_watches) }
  it { should respond_to(:events) }
  it { should respond_to(:watch_sites) }
  it { should respond_to(:teams) }
  it { should respond_to(:tailgates) }
  
  it "should require a venue type" do
    @venue.venue_type_id = nil
    @venue.should_not be_valid
  end

  it "should have correct number of game_watches" do
    3.times do
      theGameWatch = FactoryGirl.create(:game_watch, venue:@venue)
    end
    @venue.game_watches.length.should eq(3)
  end
  
  it "should have correct number of events" do
    4.times do
      theGameWatch = FactoryGirl.create(:game_watch, venue:@venue)
    end
    @venue.events.length.should eq(4)
  end

  it "should have correct number of watch_sites" do
    2.times do
      theWatchSite = FactoryGirl.create(:watch_site, venue:@venue)
    end
    @venue.watch_sites.length.should eq(2)
  end
  
  it "should have correct number of teams" do
    3.times do
      theGameWatch = FactoryGirl.create(:watch_site, venue:@venue)
    end
    @venue.teams.length.should eq(3)
  end

  it "should have correct number of tailgates" do
    3.times do
      theTailgate = FactoryGirl.create(:tailgate)
      theTailgateVenue = TailgateVenue.create tailgate_id:theTailgate.id, venue_id:@venue.id
    end
    @venue.tailgates.length.should eq(3)
  end
  
  describe "isSimilarName?" do
    before do
      @venue.name = "Bailey's Pub & Grille"
    end
    
    it "should return true for exact match" do
      @venue.isSimilarName?("Bailey's Pub & Grille").should be_true
    end
    
    it "should return false for different names" do
      @venue.isSimilarName?("Eat at Joes").should be_false
      @venue.isSimilarName?("Joes Pub").should be_false
    end
    
    it "should return true for similar names" do
      @venue.isSimilarName?("Bailey's Pub and Grille").should be_true
      @venue.isSimilarName?("Baileys Pub & Grille").should be_true
    end
    
    it "should return true for similar names when name to check is shorter" do
      @venue.name = "Cruisers Pub"
      @venue.isSimilarName?("Cruisers").should be_true
    end
  end

  describe "get_foursquare_id" do
    before do
      @theStubClient = double(Foursquare2::Client)
      Foursquare2::Client.stub(:new).and_return(@theStubClient)

      @theVenuesResponse = 
      {
        venues: [
          Hashie::Mash.new(
            {
              id: "12345",
              name: "Eat At Joes"
            }),
          Hashie::Mash.new(
            {
              id: "12345678",
              name: "Eat At Joes",
              location: {
                address: "Joes Street",
                postalCode: "48084"
              }
            }),
          Hashie::Mash.new(
            {
              id: "4af34dacf964a52073ec21e3",
              name: @venue.name,
              contact: {
                phone: "2484353044",
                formattedPhone: "(248) 435-3044",
                twitter: "Bailey'sPubTroy"
              },
              location: {
                address: "1965 W Maple Rd",
                crossStreet: "btwn Crooks Rd & Coolidge Hwy",
                lat: 42.54616442270757,
                lng: -83.17209362983704,
                distance: 186,
                postalCode: "48084",
                city: "Troy",
                state: "MI",
                country: "United States"
                },
              categories: [
                {
                  id: "4bf58dd8d48988d11d941735",
                  name: "Sports Bar",
                  pluralName: "Sports Bars",
                  shortName: "Sports Bar",
                  icon: {
                    prefix: "https://foursquare.com/img/categories_v2/nightlife/sportsbar_",
                    suffix: ".png"
                  },
                  primary: true
                }
              ],
              verified: true,
              stats: {
                checkinsCount: 2734,
                usersCount: 1097,
                tipCount: 35
              },
              url: "http://www.foxandhound.com/restaurantinfo.aspx?location=troy",
              likes: {
                count: 0,
                groups: [ ]
              },
              specials: {
                count: 2,
                items: [
                  {
                    id: "4f9add2c4fc6168ea76ec437",
                    type: "frequency",
                    message: "Every 5th check in, receive $5 off your total food bill.",
                    imageUrls: {
                      count: 0
                    },
                    description: "Unlocked every 5 check-ins",
                    finePrint: "Please show this to your server to receive your discount.  Discount applies to food only.",
                    icon: "frequency",
                    title: "Loyalty Special",
                    provider: "foursquare",
                    redemption: "standard",
                    likes: {
                      count: 0,
                      groups: [ ]
                    }
                  },
                  {
                    id: "4f9adc934fc6168ea76eaa17",
                    type: "count",
                    message: "Newbie Special.  On your first check in, receive a free order of chips & salsa.",
                    imageUrls: {
                      count: 0
                    },
                    description: "Unlocked on your 1st check-in",
                    finePrint: "Please show this to your server to receive your discount.",
                    icon: "newbie",
                    title: "Newbie Special",
                    provider: "foursquare",
                    redemption: "standard",
                    likes: {
                      count: 0,
                      groups: [ ]
                    }
                  }
                ]
              },
              hereNow: {
                count: 2,
                groups: [
                  {
                    type: "others",
                    name: "Other people here",
                    count: 2,
                    items: [ ]
                  }
                ]
              }
            })
          ]     
          }
    end
    
    it "should return existing id" do
      @venue.foursquare_id = '12345'
      subject.getFoursquareId.should eq('12345')
    end

    it "should request id, save locally, and return if no existing id when the names match" do
      @theStubClient.should_receive(:search_venues).with(ll:"#{@venue.location.latitude},#{@venue.location.longitude}",
                                                         query: @venue.name,
                                                         intent: 'match',
                                                         v:'20120609').and_return(@theVenuesResponse)
      subject.getFoursquareId.should eq('4af34dacf964a52073ec21e3')
      
      theDBVenue = Venue.where(id:@venue.id).first
      theDBVenue.foursquare_id.should eq('4af34dacf964a52073ec21e3')     
    end

    
    it "should request id, save locally, and return if no existing id when the addresses match" do
      @venue.name = "Joe"
      @venue.location.address1 = "Joes Street"
      @venue.location.postal_code = "48084"
      @theStubClient.should_receive(:search_venues).with(ll:"#{@venue.location.latitude},#{@venue.location.longitude}",
                                                         query: @venue.name,
                                                         intent: 'match',
                                                         v:'20120609').and_return(@theVenuesResponse)
      subject.getFoursquareId.should eq('12345678')
      
      theDBVenue = Venue.where(id:@venue.id).first
      theDBVenue.foursquare_id.should eq('12345678')     
    end
  end

end
