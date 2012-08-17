class BingSearchResultsForTeam < ActiveRecord::Base
  belongs_to :team
  attr_accessible :search_result
end
