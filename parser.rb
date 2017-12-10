require 'csv'
require 'active_support/time'


def main
  input_file = ARGV[0]

  if ARGV[0] and File.file?(input_file)
    parse(input_file)
  else
    puts "Usage: ruby #{$PROGRAM_NAME} csv_file"
    exit
  end
end


def convert_to_seconds(duration_string)
  if duration_string
    # split string on : and .
    duration = duration_string.split(/[:,.]/)
    # build ISO8601 duration string
    iso8601_duration = "PT#{duration[0]}H#{duration[1]}M#{duration[2]}S"
    # parse and get seconds
    seconds = ActiveSupport::Duration.parse(iso8601_duration).to_i
    # convert milliseconds string to float and add to seconds
    seconds + ".#{duration[3]}".to_f
  else
    0
  end
end


def parse(input_file)

  output_file = CSV.open("output.csv", "w")
  header_row = true

  # Read each line in the file
  File.foreach(input_file) do |line|

    begin
      # Try parsing the line
      CSV.parse(line) do |row|
        if header_row
          # TODO - convert row array to hash?
        else
          # Timestamp row[0]
          # Convert timestamp from US/Pacific to US/Eastern, ISO 8601
          timestamp_pacific = DateTime.strptime("#{row[0]} PST", '%m/%d/%y %k:%M:%S %p %Z').iso8601
          row[0] = timestamp_pacific.in_time_zone("EST")

          # Address row[1]

          # ZIP row[2]
          # Convert to string, then pad with 0s to length of 5
          zip = row[2]
          row[2] = zip.to_s.rjust(5, "0")

          # FullName row[3]
          # Convert to uppercase
          row[3] = row[3].upcase

          # FooDuration row[4]
          # Convert to floating point seconds
          foo_duration = convert_to_seconds(row[4])
          row[4] = foo_duration

          # BarDuration row[5]
          bar_duration = convert_to_seconds(row[5])
          row[5] = bar_duration

          # TotalDuration row[6]
          # Sum of FooDuration and BarDuration
          row[6] = foo_duration + bar_duration

          # Notes row[7]
        end

        header_row = false

        # Print row to stdout
        puts row.join(',')
        output_file << row
      end

    # Catch parsing error
    rescue ArgumentError => e

      # TODO - parse manually and isolate error to specific field?

      # Print error and line to stderr
      STDERR.puts "#{e.inspect} #{line}"
    end
  end

  # Close output file
  output_file.close
end

main if __FILE__==$PROGRAM_NAME
