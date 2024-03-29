require 'chunky_png'

# ZPL graphic data
graphic_data = ":::::::::JFCK0FEM0FFK03I07J01C,JFEJ03FF8K03FFCJ03I07J01C,JFCJ0IFEK07IFJ03I07J01C,00EK01F01FK0F00EJ03I07J01C,00EK01C0078J0EM03I07J01C,00EK038003CI01CM03I07J01C,00EK078001CI01CM03I07J01C,00EK07I01CI01CM03I07J01C,00EK07J0EJ0EM03I07J01C,00EK0EJ0EJ0F8L03I07J01C,00EK0EJ0EJ07FEK03JFJ01C,00EK0EJ0EJ03FF8J03JFJ01C,00EK0EJ0EK07FEJ03JFJ01C,00EK0EJ0EL01FJ03I07J01C,00EK07J0EM0FJ03I07J01C,00EK07I01CM07J03I07J01C,00EK078001CM07J03I07J01C,00EK0380038M07J03I07J01C,00EK01C0078J0800FJ03I07J01C,00EK01F01FJ01E01EJ03I07J01C,00EL0IFEJ01IFCJ03I07J01C,00EL03FF8K07FF8J03I07J01C,00CM07EM0FCK03I03K0C"

# Convert ZPL graphic data to pixel array
pixels = graphic_data.scan(/.{1,2}/).map { |chunk| chunk.to_i(36) }

# Determine image dimensions
width = pixels[0]
height = pixels[1]

# Create a new image with ChunkyPNG
image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)

# Iterate over pixels and set corresponding colors
pixels[2..-1].each_with_index do |pixel, index|
  x = index % width
  y = index / width
  image[x, y] = pixel == 0 ? ChunkyPNG::Color::WHITE : ChunkyPNG::Color::BLACK
end

# Save the image to a file
image.save('output.png')
