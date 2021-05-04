require 'kiba'
require_relative '../etl/common'

task :etl_csv => :environment do
    puts "The job is running..."

    Kiba.run(
        Kiba.parse do
            source SourceCSV, filename: 'public/healthcare-dataset-stroke-data.csv'
            # source SourceCSV, filename: 'public/numbers.csv'

            transform TransformDowncase, field: 'gender'
            transform TransformDowncase, field: 'residence_type'
            transform TransformDowncase, field: 'smoking_status'
            transform TransformBinaryFeatureToBool, field: 'hypertension'
            transform TransformBinaryFeatureToBool, field: 'heart_disease'
            transform TransformBinaryFeatureToBool, field: 'stroke'

            # transform TransformClean, field: 'number'
            # transform TransformDropFake, field: 'number'
            # transform TransformCapName, field: 'name'

            destination DestinationCSV, filename: 'public/test.csv'
        end
    )
    puts "...The job is finished"
end
