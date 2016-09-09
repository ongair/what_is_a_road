# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  road_id    :integer
#  comment    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  complete   :boolean          default(FALSE)
#

class Report < ActiveRecord::Base
  belongs_to :road
  belongs_to :user
  has_many :photos
  has_many :progresses
  has_many :steps, through: :progresses
  scope :complete, -> { where(complete: true) }
  scope :incomplete, -> { where(complete: false) }

  def current_step
  	steps.last
  end

  def current_progress
  	progresses.last
  end

  def progress_step
  	progresses.create(step: current_step.next_step)
  end
end
