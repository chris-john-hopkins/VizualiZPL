# frozen_string_literal: true

module Vizualizpl
  module Convert
    class ToJson
      def initialize(zpl:, dpi: 203, screen_dpi: 96)
        @zpl_string = zpl.gsub("\n", '')
        @dpi = dpi
        @screen_dpi = screen_dpi
        @font_size = 24
        @position_x = 0
        @position_y = 0
        @elements = []
        @barcode_on = false
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
          turn_barcode_mode_on if item.start_with?('^BC')
          set_barcode_parameters(item) if item.start_with?('^BY')
        end

        output = { elements: @elements, height: 1218, width: 812 }
        puts output
        output
      end
      # rubocop:enable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength

      private

      def set_barcode_parameters(item)
        values = item.gsub('^BY', '').split(',')

        @barcode_params = {
          module_width: values[0].to_i,
          wide_bar_to_narrow_bar_ratio: values[1].to_i,
          barcode_height_in_pixels: dots_to_pixels(values[2].to_i)
        }
      end

      def new_font_size(item)
        points = item.gsub('^CF0,', '').to_i

        @font_size = points * (@screen_dpi / 72)
      end

      def new_text_element(item)
        value = item.gsub('^FD', '')

        element = {
          type: text_element_type,
          position_x: @position_x,
          position_y: @position_y,
          font_size: @font_size,
          value: value
        }

        element = element.merge(@barcode_params) if @barcode_on
        @barcode_on = false #ensure we're no longer in barcode mode
        @elements << element
      end

      def reset_barcode_modes
        @barcode_on = false #ensure we're no longer in barcode mode
        @qr_code_on = false
      end

      def turn_barcode_mode_on
        @barcode_on = true
      end

      def text_element_type
        return 'barcode' if @barcode_on
        return 'qr_code' if @qr_code_on

        'text'
      end

      def new_graphic_box(item)
        values = item.gsub('^GB', '').split(',').map { |v| dots_to_pixels(v.to_i) }

        width = values[0]
        height = values[1]
        border_size = values[2]

        element = {
          type: 'graphic_box',
          position_x: @position_x,
          position_y: @position_y,
          font_size: @font_size,
          width: width,
          height: height,
          border_size:
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
