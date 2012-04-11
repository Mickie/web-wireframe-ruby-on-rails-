# In spec_helper:
# config.mock_with :rspec
#   ...
#   config.include(MockGeocoder)
# end
#
# In your tests:
# it 'mock geocoding' do
#   mock_geocoding!
#   address = Factory(:address)
#   address.lat.should eq(1.0)
#   address.lng.should eq(2.0)
# end

require 'geocoder/results/base'

module MockGeocoder
  def self.included(base)
    base.before :each do
      ::Geocoder.stub(:search).and_raise(RuntimeError.new 'Use "mock_geocoding!" method in your tests.')
    end
  end

  def mock_geocoding!(options = {})
    options.reverse_merge!(address1: 'address1', address2:'address2', coordinates:[1,2], state_id:1, postal_code:'98003', country_id:1 )

    MockResult.new.tap do |result|
      result.stub options
      Geocoder.stub :search => [result]
    end
  end

  class MockResult < ::Geocoder::Result::Base
    def initialize(data = [])
      super(data)
    end
  end
end