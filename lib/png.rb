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

def chunky_text_width(str)
    width, letter_spacing = 0, 2
    str.chars.each do |char|
        pixels = FONT.dig("glyphs", char, "pixels")
        width += letter_spacing + pixels.first.length unless pixels == nil
    end
    return width
end

def chunky_print(png, x, y, str, clr = chunky_clr("#000000"))
    left, letter_spacing, letter_width = 0, 2, 0
    str.chars.each_with_index do |char, position|
        pixels = FONT.dig("glyphs", char, "pixels")
        unless pixels == nil
            pixels.each_with_index do |row, j|
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
    margin, width = 4, 320
    bar_height, bar_width = 12, width - 2 * margin
    height = margin * (1 + percentages.length) + percentages.length * bar_height
    # Create PNG with border
    png = ChunkyPNG::Image.new(width + 1, height + 1, chunky_clr)
    png.rect(0, 0, width, height, chunky_clr("#505673"))
    # Create bars
    percentages.each_with_index do |data, index|
        caption, complete, total = data
        percentage = complete / total.to_f
        top = margin + (bar_height + margin) * index
        png.rect(margin, top, margin + bar_width * percentage, top + bar_height, chunky_clr, chunky_clr("#{DATA_CLRS[index]}AA"))
        png.rect(margin, top, margin + bar_width, top + bar_height, chunky_clr("#505673"))
        png = chunky_print(png, margin + 4, top + 3, caption, chunky_clr("#FFFFFFDD"))
        # Percentage text
        caption = (percentage * 100).floor.to_s.rjust(3, " ") + "%"
        left = width - (1 + margin + chunky_text_width(caption))
        png = chunky_print(png, left, top + 3, caption, chunky_clr("#FFFFFFDD"))
        # Count text
        caption = "[#{complete}/#{total}]"
        left = width - (36 + chunky_text_width(caption))
        png = chunky_print(png, left, top + 3, caption, chunky_clr("#FFFFFFDD"))
    end
    png.save(filename, :interlace => true)
    return filename
end

def phyllotaxis_png(alpha = 135.5, scale = 2.3)
    def within_bound(x, y)
        return !((x < 0) or (y < 0) or (x > 399) or (y > 399))
    end
    def point(alpha, scale, n, rounded = true)
        φ = n * alpha * Math::PI / 180
        r = scale * Math.sqrt(n)
        x = r * Math.cos(φ) + 200
        y = r * Math.sin(φ) + 200
        return rounded ? [x.round, y.round] : [x, y]
    end
    # File name
    filename = "./temp/#{(0...8).map { (65 + rand(26)).chr }.join}.png"
    width, height = 400, 400
    png = ChunkyPNG::Image.new(width, height, chunky_clr)
    # Create list of points
    points = Array.new(50000) { |n| point(alpha, scale, n) }
    # Iterate through each point and add to canvas
    points.each { |x, y| png[x, y] = chunky_clr("#FFFFFF") if within_bound(x, y) }
    # Return
    png.save(filename, :interlace => true)
    return filename
end