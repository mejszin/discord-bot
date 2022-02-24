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