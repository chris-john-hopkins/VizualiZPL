require 'wicked_pdf'

module Vizualizpl
  module Convert
    class ToPdf
      def initialize(zpl:)
        @html = ToHtml.new(zpl:).perform
      end

      def perform
        pdf = WickedPdf.new.pdf_from_string(@html)
        save_pdf(pdf)
      end

      private

      def save_pdf(pdf)
        file_path = File.expand_path('../output.pdf', __dir__)
        File.open(file_path, 'wb') do |file|
          file << pdf
        end
        file_path.to_s
      end
    end
  end
end
