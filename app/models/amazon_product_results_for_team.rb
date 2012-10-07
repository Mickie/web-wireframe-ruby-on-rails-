class AmazonProductResultsForTeam < ActiveRecord::Base
  belongs_to :team
  attr_accessible :product_result
end
