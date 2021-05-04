class AddGenderWorktypeResidencetypeSmokingstatusEnumsToPatients < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE patient_genders AS ENUM ('male', 'female', 'other');
      ALTER TABLE patients ADD gender patient_genders;

      CREATE TYPE patient_work_types AS ENUM ('private', 'self_employed', 'children', 'government', 'never_worked');
      ALTER TABLE patients ADD work_type patient_work_types;

      CREATE TYPE patient_residence_types AS ENUM ('urban', 'rural');
      ALTER TABLE patients ADD residence_type patient_residence_types;

      CREATE TYPE patient_smoking_statuses AS ENUM ('unknown', 'never_smoked', 'formerly_smoked', 'smokes');
      ALTER TABLE patients ADD smoking_status patient_smoking_statuses;
    SQL
  end

  def down
    execute <<-SQL
      DROP TYPE patient_genders;
      DROP TYPE patient_work_types;
      DROP TYPE patient_residence_types;
      DROP TYPE patient_smoking_statuses;
    SQL

    remove_column :patients, :gender
    remove_column :patients, :work_type
    remove_column :patients, :residence_type
    remove_column :patients, :smoking_status
  end
end
