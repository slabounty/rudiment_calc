RUDIMENTS_PER_PAGE = 5
TAB_LINE_SPACING = 15
RUDIMENT_SPACING = 50
TAB_LINES = 6
BARS_PER_LINE = 4

class RudimentPDFGenerator
  def initialize
  end

  def draw_notes(x_0, y_0, width, tab_space, bars_per_line, key, rudiment)
    puts "rudiment = #{rudiment}"
    three_height = @rudiments_pdf.height_of("3")
    cur_x = x_0+16
    (1..BARS_PER_LINE).each do |bar|
      @rudiments_pdf.float do
        bar_x = cur_x
        @rudiments_pdf.text_box "0", at: [bar_x, y_0 + three_height/3 - 0*TAB_LINE_SPACING]
        @rudiments_pdf.text_box "3", at: [bar_x, y_0 + three_height/3 - 4*TAB_LINE_SPACING]
        bar_x = bar_x+32
        @rudiments_pdf.text_box "3", at: [bar_x, y_0 + three_height/3 - 3*TAB_LINE_SPACING]
        bar_x = bar_x+32
        @rudiments_pdf.text_box "3", at: [bar_x, y_0 + three_height/3 - 5*TAB_LINE_SPACING]
        bar_x = bar_x+32
        @rudiments_pdf.text_box "3", at: [bar_x, y_0 + three_height/3 - 3*TAB_LINE_SPACING]
      end
      cur_x += width/4
    end
  end

  def draw_tab(x_0, y_0, width, tab_space, key, rudiment)
    @rudiments_pdf.stroke do
      # just lower the current y position
      cur_x = x_0
      cur_y = y_0

      # Tab lines
      (1..TAB_LINES).each do |i|
        @rudiments_pdf.move_to(cur_x, cur_y)
        @rudiments_pdf.line_to(cur_x+width, cur_y)
        cur_y -= tab_space
      end

      cur_x = x_0
      cur_y = y_0

      # Bar lines
      (1..BARS_PER_LINE+1).each do |i|
        @rudiments_pdf.move_to(cur_x, cur_y)
        @rudiments_pdf.line_to(cur_x, cur_y-((TAB_LINES-1)*tab_space))
        cur_x += width/BARS_PER_LINE
      end

      # Draw notes
      draw_notes(x_0, y_0, width, tab_space, BARS_PER_LINE, key, rudiment)
    end
  end

  def generate(rudiment_count, output_file, key, number_of_rudiments)
    Prawn::Document.generate(output_file) do |rudiments_pdf|
      @rudiments_pdf = rudiments_pdf
      @rudiments_pdf.text "Rudiments!"
      x_0 = 0
      y_0 = 670
      width = 512

      number_of_pages = (number_of_rudiments.to_f / RUDIMENTS_PER_PAGE.to_f).ceil
      puts "number_of_pages = #{number_of_pages}"

      rc = rudiment_count.to_a
      rc_element = 0

      (1..number_of_pages).each do |page|
        (1..RUDIMENTS_PER_PAGE).each do |i|
          rudiment = rc[rc_element][0]
          draw_tab(x_0, y_0, width, TAB_LINE_SPACING, key, rudiment)
          y_0 -= ((RUDIMENTS_PER_PAGE-1)*TAB_LINE_SPACING + RUDIMENT_SPACING)
          rc_element += 1
        end
        x_0 = 0
        y_0 = 670
        width = 512
        @rudiments_pdf.start_new_page unless page == number_of_pages
      end
      @rudiments_pdf.number_pages "Page <page> of <total>", at: [@rudiments_pdf.bounds.right - 100, 0]
    end
  end
end
