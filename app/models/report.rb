class Report < ActiveRecord::Base
  belongs_to :road
  belongs_to :user
  has_many :photos
end
