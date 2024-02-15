# frozen_string_literal: true

require_relative 'vizualizpl/convert/to_hash'
require_relative 'vizualizpl/convert/to_html'
require_relative 'vizualizpl/convert/to_pdf'

require 'pry'
require 'wicked_pdf'
require 'barby'
require 'chunky_png'

WickedPdf.config.merge(exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf'))

module Vizualizpl
end
