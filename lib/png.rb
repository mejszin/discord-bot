def chunky_clr(hex = nil)
    return ChunkyPNG::Color::TRANSPARENT if hex == nil
    return ChunkyPNG::Color.from_hex(hex)
end

file = File.open("./data/seven-plus.json")
FONT = JSON.load(file)
file.close

DATA_CLRS = [
    "#8dd3c7", "#bebada", "#fb8072", "#80b1d3", "#fdb462",
    "#b3de69", "#fccde5", "#d9d9d9", "#ffffb3",
]

def chunky_print(png, x, y, str, clr = chunky_clr("#000000"))
    left, letter_spacing, letter_width = 0, 2, 0
    str.chars.each_with_index do |char, position|
        letter = FONT["glyphs"][char]
        if letter.key?("pixels")
            letter["pixels"].each_with_index do |row, j|
                letter_width = row.length
                row.each_with_index do |state, i|
                    png[x + i + left, y + j] = clr if state == 1
                end
            end
            left += letter_spacing + letter_width
        end
    end
    return png
end

def test_png
    # File name
    filename = "./temp/#{(0...8).map { (65 + rand(26)).chr }.join}.png"
    # Create PNG with border
    width, height = 200, 100
    png = ChunkyPNG::Image.new(width, height, chunky_clr)
    png.rect(0, 0, width - 1, height - 1, chunky_clr("#505673"), chunky_clr("#ffffb3"))
    png = chunky_print(png, 10, 20, "TEST STRING!?")
    png.save(filename, :interlace => true)
    return filename
end

def bar_graph_png(percentages = [0.3, 0.5, 0.1, 0.7, 0.4])
    # File name
    filename = "./temp/#{(0...8).map { (65 + rand(26)).chr }.join}.png"
    # Base dimensions
    margin, width = 4, 240
    bar_height, bar_width = 12, width - 2 * margin
    height = margin * (1 + percentages.length) + percentages.length * bar_height
    # Create PNG with border
    png = ChunkyPNG::Image.new(width + 1, height + 1, chunky_clr)
    png.rect(0, 0, width, height, chunky_clr("#505673"))
    # Create bars
    percentages.each_with_index do |data, index|
        caption, percentage = data
        top = margin + (bar_height + margin) * index
        png.rect(margin, top, margin + bar_width * percentage, top + bar_height, chunky_clr, chunky_clr("#{DATA_CLRS[index]}AA"))
        png.rect(margin, top, margin + bar_width, top + bar_height, chunky_clr("#505673"))
        png = chunky_print(png, margin + 4, top + 3, caption, chunky_clr("#FFFFFFDD"))
    end
  # png[1,1] = ChunkyPNG::Color.rgba(10, 20, 128, 128)
  # png[2,1] = ChunkyPNG::Color('black @ 0.5')
  # png.line(1, 1, 100, 80, ChunkyPNG::Color.from_hex('#aa007f'))
    png.save(filename, :interlace => true)
    return filename
end