RUDIMENTS_PER_PAGE = 5
TAB_LINE_SPACING = 15
RUDIMENT_SPACING = 50
TAB_LINES = 6
BARS_PER_LINE = 4
NOTE_SPACING = 14

KEYS = {
  "C" => {
    bass_line: [
      { string: 5, fret: "3" },
      { string: 0, fret: "0" },
      { string: 4, fret: "2" },
      { string: 0, fret: "0" },
      { string: 6, fret: "3" },
      { string: 0, fret: "0" },
      { string: 4, fret: "2" },
      { string: 0, fret: "0" },
    ],
    melody_line: [
      { string: 1, fret: "0" },
      { string: 1, fret: "0" },
      { string: 1, fret: "0" },
      { string: 1, fret: "0" },
      { string: 1, fret: "0" },
      { string: 1, fret: "0" },
      { string: 1, fret: "0" },
      { string: 1, fret: "0" },
    ]
  }
}

class RudimentPDFGenerator
  def initialize
  end

  def draw_notes(x_0, y_0, width, tab_space, bars_per_line, key, rudiment)
    rudiment_chars = rudiment.chars
    key_values = KEYS[key]
    three_height = @rudiments_pdf.height_of("3")
    cur_x = x_0+NOTE_SPACING/2
    (1..BARS_PER_LINE).each do |bar|
      bar_x = cur_x
      rudiment_chars.each_with_index do |c, i|
        @rudiments_pdf.float do
          case c
          when "p"
            @rudiments_pdf.text_box key_values[:bass_line][i][:fret],
              at: [bar_x,
                   y_0 + three_height/3 - (key_values[:bass_line][i][:string]-1)*TAB_LINE_SPACING]
            @rudiments_pdf.text_box key_values[:melody_line][i][:fret],
              at: [bar_x,
                   y_0 + three_height/3 - (key_values[:melody_line][i][:string]-1)*TAB_LINE_SPACING]
            bar_x = bar_x+NOTE_SPACING
          when "t"
            @rudiments_pdf.text_box key_values[:bass_line][i][:fret],
              at: [bar_x,
                   y_0 + three_height/3 - (key_values[:bass_line][i][:string]-1)*TAB_LINE_SPACING]
            bar_x = bar_x+NOTE_SPACING
          when "f"
            @rudiments_pdf.text_box key_values[:melody_line][i][:fret],
              at: [bar_x,
                   y_0 + three_height/3 - (key_values[:melody_line][i][:string]-1)*TAB_LINE_SPACING]
            bar_x = bar_x+NOTE_SPACING
          when "0"
            bar_x = bar_x+NOTE_SPACING
          end
        end
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

      rc = rudiment_count.to_a
      rc_element = 0

      rudiments_pdf.font_size(10) do
        (1..number_of_pages).each do |page|
          (1..RUDIMENTS_PER_PAGE).each do |i|
            #(1..number_of_rudiments).each do |i|
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
end
