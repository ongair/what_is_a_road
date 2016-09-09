# == Schema Information
#
# Table name: steps
#
#  id           :integer          not null, primary key
#  name         :string
#  step_type    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  prompt_text  :string
#  next_step_id :integer
#

class Step < ActiveRecord::Base
	has_many :progresses
	has_many :reports, through: :progresses
	belongs_to :next_step, class_name: 'Step'
end
