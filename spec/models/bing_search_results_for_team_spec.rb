require 'spec_helper'

describe BingSearchResultsForTeam do
  before do
    mock_geocoding!
    
    @team = FactoryGirl.create(:team)
    @team.create_bing_search_results
  end

  subject { @team.bing_search_results }
  
  it { should respond_to(:search_result) }
end
