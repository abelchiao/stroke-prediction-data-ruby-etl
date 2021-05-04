require 'kiba'
require_relative '../etl/common'

task :etl_csv => :environment do
    puts "The job is running..."

    Kiba.run(
        Kiba.parse do
            source SourceCSV, filename: 'public/healthcare-dataset-stroke-data.csv'

            transform TransformDowncase, fields: ['gender', 'residence_type', 'smoking_status', 'work_type']
            transform TransformBinaryFeatureToBool, fields: ['hypertension', 'heart_disease', 'stroke']
            transform TransformMapYesNoToBool, field: 'ever_married'
            transform TransformReplaceSpacesDashesWithUnderscores, field: 'work_type'
            transform TransformReplaceSpacesDashesWithUnderscores, field: 'smoking_status'
            transform TransformNilOutMissingFields, field: 'bmi'
            transform TransformMapField, field: 'work_type', old_val: 'govt_job', new_val: 'government'

            destination DestinationCSV, filename: 'public/test.csv'
        end
    )
    puts "...The job is finished"
end

task :etl_db => :environment do
    puts "The job is running..."

    Kiba.run(
        Kiba.parse do
            source SourceCSV, filename: 'public/healthcare-dataset-stroke-data.csv'

            transform TransformDowncase, fields: ['gender', 'residence_type', 'smoking_status', 'work_type']
            transform TransformBinaryFeatureToBool, fields: ['hypertension', 'heart_disease', 'stroke']
            transform TransformMapYesNoToBool, field: 'ever_married'
            transform TransformReplaceSpacesDashesWithUnderscores, field: 'work_type'
            transform TransformReplaceSpacesDashesWithUnderscores, field: 'smoking_status'
            transform TransformNilOutMissingFields, field: 'bmi'
            transform TransformMapField, field: 'work_type', old_val: 'govt_job', new_val: 'government'

            destination DestinationDB
        end
    )
    puts "...The job is finished"
end

