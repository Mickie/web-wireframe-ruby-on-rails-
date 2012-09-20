class Photo < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :image,
                    :styles => { :thumbnail => "300x300#" },
                    :storage => :s3,
                    :s3_credentials => S3_CREDENTIALS

  attr_accessible :latitude, :longitude, :image

end
