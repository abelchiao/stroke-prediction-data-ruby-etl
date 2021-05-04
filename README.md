# Stroke Patient Data ETL

Data from: https://www.kaggle.com/fedesoriano/stroke-prediction-dataset

This project was an exercise in building an ETL (extract, transform, load) data pipeline in the context of a Ruby on Rails application. A CSV file containing 5,110 patient entries is read in, processed for uniformity/conformity with Ruby conventions, and either written to a new CSV or dumped to a PostgreSQL database. Custom Rake tasks provided a CLI for initiating data import. 

The [Kiba gem](https://github.com/thbar/kiba) was used to write extract, transform, load logic. The following provides an overview of the ETL process.

```ruby
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
```

___
## Extract

The extract step reads in each row of the CSV, maps it to a hash, downcases the keys, and yields it to the transform steps.

```ruby
class SourceCSV
    def initialize(filename:)
        @filename = filename
    end

    def each
        csv = CSV.open(@filename, headers:true)

        csv.each do |row|
            row = row.to_hash
            row.keys.each do |field_name|
                if field_name != field_name.downcase
                    row[field_name.downcase] = row.delete(field_name)
                end
            end

            yield(row)
        end

        csv.close
    end
end
```

___
## Transform

The workflow applies the following transformations to the data:
* downcase headers and fields
* transform yes/no, 0/1 binary attributes to boolean values
* replace spaces and dashes with underscores
* nil out missing fields
* map field values to new values that are more consistent with Ruby conventions/downstream processes

Example of transformation mapping 0/1 to true/false:

```ruby
class TransformBinaryFeatureToBool
    def initialize(fields:)
        @fields = fields
    end

    def process(row)
        @fields.each do |field|
            row[field] = !!row[field]
        end

        row
    end
end
```

___
## Load

After the transformations have been executed, the cleaned records can be dumped to a new CSV or written to a table in a PostgreSQL database using an ActiveRecord model.

The snippet below defines the database load step:

```ruby
class DestinationDB
    def initialize
        @headers_processed = false
    end

    def write(row)
        if !@headers_processed
            @headers_processed = true
        end
        
        if Patient.exists?(row['id'])
            patient = Patient.find(row['id'])
            patient.update(row)
        else
            Patient.create(row)
        end
    end
end
```
___

## Data integrity - ActiveRecord model and database constraints

Certain fields have a finite number of possible values. Setting enums on the model toggles restrictions on data saved to the database through ActiveRecord to prevent invalid entries.

Enums are set on the ActiveRecord model:
```ruby
class Patient < ApplicationRecord
    ...
    enum smoking_status: {
        unknown: 'unknown',
        never_smoked: 'never_smoked',
        formerly_smoked: 'formerly_smoked',
        smokes: 'smokes'
    }
    ...
end
```

Enums on the model also activate some really convenient methods we can use. For example:
```ruby
patient = Patient.new

patient.smokes! # => true
patient.smokes? # => true
patient.never_smoked? # => false
patient.smoking_status # => 'smokes'

Patient.smokes # => Collection of all Patients that smoke
```


\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-
<br>

Setting enums at the database level prevents insertion of invalid entries via direct database manipulations (SQL, Postgres CLI, etc.).

Example database migration/SQL to add enums column to Postgres:

```ruby
class AddGenderWorktypeResidencetypeSmokingstatusEnumsToPatients < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      ...
      CREATE TYPE patient_smoking_statuses AS ENUM ('unknown', 'never_smoked', 'formerly_smoked', 'smokes');
      ALTER TABLE patients ADD smoking_status patient_smoking_statuses;
    SQL
  end

  def down
    execute <<-SQL
      ...
      DROP TYPE patient_smoking_statuses;
    SQL
    ...
    remove_column :patients, :smoking_status
  end
end
```
___

# Useful resources:

I found the following resources to be really helpful in learning how to put this all together:
* [Build The World's Simplest ETL (Extract, Transform, Load) Pipeline in Ruby With Kiba](https://towardsdatascience.com/build-the-worlds-simplest-etl-extract-transform-load-pipeline-in-ruby-with-kiba-e7093a29d35)
* [Kiba Wiki](https://github.com/thbar/kiba/wiki)
* [How to run Kiba ETL in a Rails environment?](https://thibautbarrere.com/2015/09/26/how-to-run-kiba-in-a-rails-environment)
* [Ruby on Rails - How to Create Perfect Enum in 5 Steps](https://sipsandbits.com/2018/04/30/using-database-native-enums-with-rails/)
