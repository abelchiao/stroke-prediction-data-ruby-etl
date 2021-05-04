require 'kiba'
require_relative '../etl/common'

task :etl => :environment do
    puts "The job is running..."

    Kiba.run(
        Kiba.parse do
            source SourceCSV, filename: 'public/healthcare-dataset-stroke-data.csv'
            # source SourceCSV, filename: 'public/numbers.csv'

            # transform TransformClean, field: 'number'
            # transform TransformDropFake, field: 'number'
            # transform TransformCapName, field: 'name'

            destination DestinationCSV, filename: 'public/test.csv'
        end
    )
    puts "...The job is finished"
end
