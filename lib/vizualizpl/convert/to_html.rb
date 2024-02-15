require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
require 'base64'

module Vizualizpl
  module Convert
    class ToHtml
      def initialize(zpl:)
        @hash = ToJson.new(zpl:).perform
      end

      def perform
        html = "<div style=\"position: relative; width: #{@hash[:width]}px; height: #{@hash[:height]}px;\">"

        @hash[:elements].each do |element|
          case element[:type]
          when 'graphic_box'
            html += "<div style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px; width: #{element[:width]}px; height: #{element[:height]}px; box-sizing: border-box; border: #{element[:border_size]}px solid black;\"></div>"
          when 'text'
            html += "<div style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px; font-size: #{element[:font_size]}px; font-family: #{element[:font_family]};\">#{element[:value]}</div>"
          when 'barcode'
            barcode = generate_barcode(element)
            html += "<img src='data:image/png;base64,#{Base64.encode64(barcode)}' style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px;\" />"
          end
        end
        html += '</div>'
        puts html
        html
      end


      private

      def generate_barcode(element)
        barcode = Barby::Code128B.new(element[:value])
        png = barcode.to_png(xdim: element[:module_width], height: element[:barcode_height_in_pixels])
        png.to_s
      end
    end
  end
end
