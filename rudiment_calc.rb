require "optparse"
require "prawn"
require_relative "./histogram"
require_relative "./rudiment_pdf_generator"

# Main

options = {
  verbose: false,    # Default values
  key: "C",
  output_file: "rudiments.pdf",
  number_of_rudiments: 10,
  print_histogram: false,
}
parser = OptionParser.new
parser.on('-k KEY', '--key', 'Key to generate rudiments in') do |value|
  options[:key] = value
end
parser.on('-n COUNT', '--number_of_rudiments', 'Number of rudiments') do |value|
  options[:number_of_rudiments] = value.to_i
end
parser.on('-v', '--verbose', 'Print everything') do |value|
  options[:verbose] = true
end
parser.on('-p', '--print_histogram', 'Print histogram') do |value|
  options[:print_histogram] = true
end
parser.on('-o OUTPUT_FILE', '--output_file', 'Output PDF file') do |value|
  options[:output_file] = value
end
parser.parse!
puts "options = #{options}" if options[:verbose]

# Generate and print histogram
histogram = Histogram.new
rudiment_count = histogram.generate_histogram(ARGV[0])
histogram.print_histogram if options[:print_histogram]

rudiment_pdf_generator = RudimentPDFGenerator.new
rudiment_pdf_generator.generate(rudiment_count, options[:output_file], options[:key], options[:number_of_rudiments])
