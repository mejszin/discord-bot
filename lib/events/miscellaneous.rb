$bot.message(start_with: '~quote') do |event|
    require 'csv'
    author, quote = CSV.read('./data/quotes.csv').sample
    author = "Anonymous" if author == ""
    event.respond ">>> #{quote} *- #{author}*"
end

$bot.message(start_with: '~sadcat') do |event|
    event.respond File.readlines('./data/sadcats.txt').sample
end

$bot.message(start_with: '~lofi') do |event|
    event.respond File.readlines('./data/lofi.txt').sample
end

$bot.message(start_with: '~prompt') do |event|
    event.respond format_standard(File.readlines('./data/prompts.txt').sample) if event.content == "~prompt"
end

$bot.message(start_with: '~prompt-add') do |event|
    words = event.content.split(" ")
    if words.length > 1
        desc = words[1..-1].join(" ")
        File.open('./data/prompts.txt', 'a') { |f| f.write(desc) }
        event.respond format_success("Added prompt!")
    else
        event.respond format_usage("~prompt-add <description>")
    end
end