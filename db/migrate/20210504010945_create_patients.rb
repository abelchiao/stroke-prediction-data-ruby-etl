class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients do |t|
      # t.integer :gender
      t.float :age
      t.boolean :hypertension
      t.boolean :heart_disease
      t.boolean :ever_married
      # t.integer :work_type
      # t.integer :residence_type
      t.float :avg_glucose_level
      t.float :bmi
      # t.integer :smoking_status
      t.boolean :stroke

      t.timestamps
    end
  end
end
