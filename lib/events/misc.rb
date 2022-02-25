$bot.message(start_with: '~quote') do |event|
    require 'csv'
    author, quote = CSV.read('./data/quotes.csv').sample
    author = "Anonymous" if author == ""
    event.respond ">>> #{quote} *- #{author}*"
end

$bot.message(start_with: '~sadcat') do |event|
    event.respond File.readlines('./data/sadcats.txt').sample
end

$bot.message(start_with: '~aesthetic') do |event|
    event.respond File.readlines('./data/aesthetic.txt').sample
end

$bot.message(start_with: '~prompt') do |event|
    args = event.content.split(" ")
    return unless args.shift == '~prompt'
    if args.empty?
        event.respond format_standard(File.readlines('./data/prompts.txt').sample) 
    else
        command = args.shift
        text = args.join(' ')
        if (command == "add") && (text != '')
            File.open('./data/prompts.txt', 'a') { |f| f.write(text) }
            event.respond format_success("Added prompt!")
        else
            event.respond format_usage("~prompt add <text>")
        end
    end
end