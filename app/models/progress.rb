# == Schema Information
#
# Table name: progresses
#
#  id         :integer          not null, primary key
#  report_id  :integer
#  step_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Progress < ActiveRecord::Base
  belongs_to :report
  belongs_to :step
end
