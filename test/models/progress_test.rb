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

require 'test_helper'

class ProgressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
