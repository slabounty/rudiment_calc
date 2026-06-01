puts "input file = #{ARGV[0]}"
file = ARGV[0]
rudiment_count = {}
File.foreach(file) do |line|
  line.chomp!.downcase!
  next if line.start_with?("title")
  if rudiment_count.has_key?(line)
    rudiment_count[line] += 1
  else
    rudiment_count[line] = 1
  end
end

rudiment_count = rudiment_count.sort_by { |_key, value| -value }.to_h
rudiment_count.each do |key, value|
  puts "#{key}/#{value}: #{"*"*value}" if value > 2
end
