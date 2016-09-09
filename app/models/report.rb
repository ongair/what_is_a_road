class Report < ActiveRecord::Base
  belongs_to :road
  belongs_to :user
  has_many :photos
  scope :complete, -> { where(complete: true) }
  scope :incomplete, -> { where(complete: false) }
end
