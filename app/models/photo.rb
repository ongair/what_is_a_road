# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  file_url   :string
#  report_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Photo < ActiveRecord::Base
  belongs_to :report
end
