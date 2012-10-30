class EventPost < ActiveRecord::Base
  belongs_to :visiting_post, :class_name => "Post", :foreign_key => "visiting_post_id"
  belongs_to :home_post, :class_name => "Post", :foreign_key => "home_post_id"
  belongs_to :event
  attr_accessible :home_flag, :visiting_flag
end
