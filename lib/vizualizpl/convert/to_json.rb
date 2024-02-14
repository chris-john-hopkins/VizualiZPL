# frozen_string_literal: true

module Vizualizpl
  module Convert
    # converts zpl string to a json object
    # example output
    # {
    # 	height: ,
    # 	width: ,
    # 	elements: [
    # 		{type: 'image | text | qr | barcode | border | divider', position_x: , position_y: , font_size: , font:, content: }
    # 	]
    # }

    ZPL_COMMANDS = [
      '^XA', '^XZ',
      '^FO', '^A', '^FD',
      '^B3', '^BY', '^BC', '^BQ',
      '^GF', '^XG', '^IM', '^CI',
      '^FS', '^LL', '^LS', '^LH',
      '^PW', '^MM', '^MN', '^MD', '^MT',
      '^HH', '^HS', '^XFR'
    ].freeze

    class ToJson
      def initialize(zpl:, dpi: 203, screen_dpi: 96)
        @zpl_string = zpl.gsub("\n", '')
        @dpi = dpi
        @screen_dpi = screen_dpi
        @font_size = 24
        @position_x = 0
        @position_y = 0
        @elements = []
      end

      # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength
      def perform
        zpl_string_to_array.each do |item|
          next if item.start_with?('^XA')
          next if item.start_with?('^XZ')
          next if item.start_with?('^FX')
          next if item.start_with?('^FS')
          next if item.start_with?('^FR')

          new_font_size(item) if item.start_with?('^CF0')
          new_position(item) if item.start_with?('^FO')
          new_graphic_box(item) if item.start_with?('^GB')
          new_text_element(item) if item.start_with?('^FD')
        end

        { elements: @elements }
      end
      # rubocop:enable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength

      private

      def new_font_size(item)
        points = item.gsub('^CF0,', '').to_i

        @font_size = points * (@dpi / 72)
      end

      def new_text_element(item)
        value = item.gsub('^FD', '')

        element = {
          type: 'text',
          position_x: @position_x,
          position_y: @position_y,
          font_size: @font_size,
          value: value
        }

        @elements << element
      end

      def new_graphic_box(item)
        values = item.gsub('^GB', '').split(',').map { |v| dots_to_pixels(v.to_i) }

        width = values[0]
        height = values[1]
        thickness = values[2]

        perimeter = 2 * (width + height)
        area = width * height
        line_area = (perimeter - 2 * (width + height) + 4 * thickness) * thickness
        fill_percentage = (area - line_area).to_f / area * 100

        element = {
          type: 'graphic_box',
          position_x: @position_x,
          position_y: @position_y,
          font_size: @font_size,
          width: width,
          height: height,
          fill_percentage: fill_percentage.round(2),
          thickness: thickness
        }

        @elements << element
      end

      def new_position(item)
        positions = item.gsub('^FO', '').split(',')
        @position_x = positions.first
        @position_y = positions.last
      end

      def zpl_string_to_array
        @zpl_string.gsub!(/(\s+)/, ' ').split(/(?=\^)/).map(&:strip)
      end

      def dots_to_pixels(dots)
        inches = dots.to_f / @dpi
        pixels = inches * @screen_dpi
        pixels.round
      end
    end
  end
end
