require 'csv'

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

class DestinationCSV
    def initialize(filename:)
        @csv = CSV.open(filename, 'w')
        @headers_written = false
    end

    def write(row)
        if !@headers_written
            @headers_written = true
            
            cleaned_headers = row.keys.map { |key| key.downcase }

            @csv << cleaned_headers
            # @csv << row.keys
        end
        @csv << row.values
    end

    def close
        @csv.close
    end
end

class TransformDowncase
    def initialize(fields:)
        @fields = fields
    end

    def process(row)
        @fields.each do |field|
            row[field].downcase!
        end
        # row[@field].downcase!
        row
    end
end

class TransformBinaryFeatureToBool
    def initialize(fields:)
        @fields = fields
    end

    def process(row)
        @fields.each do |field|
            row[field] = !!row[field]
        end
        # row[@field] = !!row[@field]
        row
    end
end


# class TransformClean
#     def initialize(field:)
#         @field = field
#     end

#     def process(row)
#         number = row[@field]

#         row[:number_cleaned] = number.tr('^0-9', '')
        
#         row[:digit_count] = row[:number_cleaned].length

#         row
#     end
# end

# class TransformDropFake
#     def initialize(field:)
#         @field = field
#     end

#     def process(row)
#         number = row[@field]
#         row[:digit_count] == 10 ? row : nil
#     end
# end

# class TransformCapName
#     def initialize(field:)
#         @field = field
#     end

#     def process(row)
#         # name = row[@field]
#         row[:yelled_name] = row[@field].upcase
#         row
#     end
# end

