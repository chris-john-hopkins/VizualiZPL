require 'barby'
require 'barby/barcode/code_128'
require 'rqrcode'
require 'barby/barcode'
require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'
require 'base64'
require 'chunky_png'

module ByteHelper
  def self.hex_to_bytes(hex)
    hex.scan(/../).map(&:hex)
  end
end

module Vizualizpl
  module Convert
    class ToHtml
      def initialize(zpl:)
        @hash = ToHash.new(zpl:).perform
      end

      def perform
        html = "<div style=\"position: relative; width: #{@hash[:width]}px; border: 1px solid black; height: #{@hash[:height]}px;\">"

        @hash[:elements].each do |element|
          case element[:type]
          when 'graphic_box'
            html += "<div style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px; width: #{element[:width]}px; height: #{element[:height]}px; box-sizing: border-box; border: #{element[:border_size]}px solid black;\"></div>"
          when 'text'
            html += "<div style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px; font-size: #{element[:font_size]}px; font-family: #{element[:font_family]}; width:100%;\">#{element[:value]}</div>"
          when 'barcode'
            barcode = generate_barcode(element)
            html += "<img src='data:image/png;base64,#{Base64.encode64(barcode)}' style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px;\" />"
          when 'image'
            html += "<img src='data:image/png;base64,#{base64}' style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px;\" />"
          when 'qr_code'
            binding.pry
            qr_code = generate_qr_code(element)
            html += "<img src='data:image/png;base64,#{qr_code}' style=\"position: absolute; left: #{element[:position_x]}px; top: #{element[:position_y]}px;\" />"
          end

        end

        html += '</div>'
        puts html
        html
      end

      private

      def base64
        "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"
      end

      def generate_barcode(element)
        barcode = Barby::Code128B.new(element[:value])
        png = barcode.to_png(xdim: element[:module_width], height: element[:barcode_height_in_pixels])
        png.to_s
      end

      def generate_qr_code(element)
        value = element[:value].gsub('MM:A', '')

        qr = Barby::QrCode.new(value)

        # Create PNG image
        png = qr.to_png(xdim: 10)

        # Convert PNG image to base64 encoded string
        base64_png = Base64.encode64(png.to_s)

        base64_png
      end
    end
  end
end
