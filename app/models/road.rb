# == Schema Information
#
# Table name: roads
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Road < ActiveRecord::Base
	has_many :reports
end
