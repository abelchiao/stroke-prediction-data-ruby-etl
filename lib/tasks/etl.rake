require 'kiba'
require_relative '../etl/common'

task :etl_csv => :environment do
    puts "The job is running..."

    Kiba.run(
        Kiba.parse do
            source SourceCSV, filename: 'public/healthcare-dataset-stroke-data.csv'
            # source SourceCSV, filename: 'public/numbers.csv'

            transform TransformDowncase, fields: ['gender', 'residence_type', 'smoking_status', 'work_type']
            transform TransformBinaryFeatureToBool, fields: ['hypertension', 'heart_disease', 'stroke']

            # transform TransformClean, field: 'number'
            # transform TransformDropFake, field: 'number'
            # transform TransformCapName, field: 'name'

            destination DestinationCSV, filename: 'public/test.csv'
        end
    )
    puts "...The job is finished"
end
