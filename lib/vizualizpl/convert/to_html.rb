require 'json'

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
            html += "<div style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px; width: #{element[:width]}px; height: #{element[:height]}px; border: 1px solid black;\"></div>"
          when 'text'
            html += "<div style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px; font-size: #{element[:font_size]}px; font-family: #{element[:font_family]};\">#{element[:value]}</div>"
          when 'barcode'
            html += "<div style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px; font-size: #{element[:font_size]}px;\">Barcode: #{element[:value]}</div>"
          end
        end
        binding.pry
        html += '</div>'
        html
      end
    end
  end
end
