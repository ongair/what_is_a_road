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

require 'test_helper'

class StepTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
