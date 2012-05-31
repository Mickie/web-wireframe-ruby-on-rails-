class UserLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :location, :dependent => :destroy

  accepts_nested_attributes_for :location
end
