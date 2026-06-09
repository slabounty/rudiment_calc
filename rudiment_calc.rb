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
  empty_measures: "NONE",
  groove: "ALT",
}
parser = OptionParser.new do |opts|
  opts.on("-k KEY", "--key", %w[C G D A E], "Key to generate rudiments in. Must be one of C, G, D, A, E") do |value|
    options[:key] = value
  end
  opts.on("-n COUNT", "--number_of_rudiments", "Number of rudiments") do |value|
    options[:number_of_rudiments] = value.to_i
  end
  opts.on("-v", "--verbose", "Print everything") do |value|
    options[:verbose] = true
  end
  opts.on("-p", "--print_histogram", "Print histogram") do |value|
    options[:print_histogram] = true
  end
  opts.on("-o OUTPUT_FILE", "--output_file", "Output PDF file") do |value|
    options[:output_file] = value
  end
  opts.on("-e EMPTY_MEASURES", "--empty_measures", %w[NONE ALT END], "Empty/bass only measures. Must be one of NONE, ALT, END") do |value|
    options[:empty_measures] = value
  end
  opts.on("-g GROOVE", "--groove", %w[ALT STEADY], "Empty/bass only measures. Must be one of NONE, ALT, END") do |value|
    options[:groove] = value
  end
end

begin
  parser.parse!
rescue OptionParser::ParseError => e
  # Handle invalid choices, missing arguments, or type mismatches
  puts "Error: #{e.message}"
  puts parser
  exit 1
end

puts parser if options[:verbose]

# Generate and print histogram
histogram = Histogram.new
rudiment_count = histogram.generate_histogram(ARGV[0])
histogram.print_histogram if options[:print_histogram]

rudiment_pdf_generator = RudimentPDFGenerator.new
rudiment_pdf_generator.generate(rudiment_count, options[:output_file], options[:key], options[:number_of_rudiments], options[:empty_measures], options[:groove])
