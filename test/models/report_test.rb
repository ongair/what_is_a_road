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

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
