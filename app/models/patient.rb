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
class Patient < ApplicationRecord
    enum gender: {
        male: 'male',
        female: 'female',
        other: 'other'
    }

    enum residence_type: {
        urban: 'urban',
        rural: 'rural'
    }

    enum smoking_status: {
        unknown: 'unknown',
        never_smoked: 'never_smoked',
        formerly_smoked: 'formerly_smoked',
        smokes: 'smokes'
    }

    enum work_type: {
        privately_employed: 'private',
        self_employed: 'self_employed',
        children: 'children',
        government: 'government',
        never_worked: 'never_worked'
    }
end
