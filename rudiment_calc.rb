require "prawn"

RUDIMENTS_PER_PAGE = 5
TAB_LINE_SPACING = 15
RUDIMENT_SPACING = 50
TAB_LINES = 6
BARS_PER_LINE = 4

def print_histogram(rudiment_count)
  rudiment_count.each do |key, value|
    puts "#{key}/#{value}: #{"*"*value}" if value > 2
  end
end

def draw_notes(x_0, y_0, width, tab_space, bars_per_line)
  three_height = height_of("3")
  cur_x = x_0+16
  (1..BARS_PER_LINE).each do |bar|
    float do
      bar_x = cur_x
      text_box "0", at: [bar_x, y_0 + three_height/3 - 0*TAB_LINE_SPACING]
      text_box "3", at: [bar_x, y_0 + three_height/3 - 4*TAB_LINE_SPACING]
      bar_x = bar_x+32
      text_box "3", at: [bar_x, y_0 + three_height/3 - 3*TAB_LINE_SPACING]
      bar_x = bar_x+32
      text_box "3", at: [bar_x, y_0 + three_height/3 - 5*TAB_LINE_SPACING]
      bar_x = bar_x+32
      text_box "3", at: [bar_x, y_0 + three_height/3 - 3*TAB_LINE_SPACING]
    end
    cur_x += width/4
  end
end

def draw_tab(x_0, y_0, width, tab_space)
  stroke do
    # just lower the current y position
    cur_x = x_0
    cur_y = y_0

    # Tab lines
    (1..TAB_LINES).each do |i|
      move_to(cur_x, cur_y)
      line_to(width, cur_y)
      cur_y -= tab_space
    end

    cur_x = x_0
    cur_y = y_0

    # Bar lines
    (1..BARS_PER_LINE+1).each do |i|
      move_to(cur_x, cur_y)
      line_to(cur_x, cur_y-((TAB_LINES-1)*tab_space))
      cur_x += width/BARS_PER_LINE
    end

    # Draw notes
    draw_notes(x_0, y_0, width, tab_space, BARS_PER_LINE)
  end
end

def generate_rudiment_pdf(rudiment_count)
  Prawn::Document.generate("rudiments.pdf") do
    text "Rudiments!"
    x_0 = 0
    y_0 = 670
    width = 512

    (1..RUDIMENTS_PER_PAGE).each do |i|
      draw_tab(x_0, y_0, width, TAB_LINE_SPACING)
      y_0 -= ((RUDIMENTS_PER_PAGE-1)*TAB_LINE_SPACING + RUDIMENT_SPACING)
    end
  end
end

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

print_histogram(rudiment_count)

generate_rudiment_pdf(rudiment_count)
