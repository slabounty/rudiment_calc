class Histogram
  def initialize
    @rudiment_count = {}
  end

  def print_histogram
    @rudiment_count.each do |key, value|
      puts "#{key}/#{value}: #{"*"*value}" if value > 2
    end
  end

  def generate_histogram(input_file, verbose: false)
    puts "input file = #{ARGV[0]}" if verbose

    File.foreach(input_file) do |line|
      line.chomp!.downcase!
      next if line.start_with?("title")
      if @rudiment_count.has_key?(line)
        @rudiment_count[line] += 1
      else
        @rudiment_count[line] = 1
      end
    end

    @rudiment_count = @rudiment_count.sort_by { |_key, value| -value }.to_h
    @rudiment_count
  end
end
