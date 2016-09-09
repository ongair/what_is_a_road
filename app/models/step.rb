class Step < ActiveRecord::Base
	has_many :progresses
	has_many :reports, through: :progresses
	belongs_to :next_step, class_name: 'Step'
end
