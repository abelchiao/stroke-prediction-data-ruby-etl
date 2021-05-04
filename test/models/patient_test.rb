# == Schema Information
#
# Table name: patients
#
#  id                :bigint           not null, primary key
#  age               :float
#  avg_glucose_level :float
#  bmi               :float
#  ever_married      :boolean
#  gender            :enum
#  heart_disease     :boolean
#  hypertension      :boolean
#  residence_type    :enum
#  smoking_status    :enum
#  stroke            :boolean
#  work_type         :enum
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
