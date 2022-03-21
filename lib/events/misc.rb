$bot.message(start_with: PREFIX + 'quote') do |event|
    require 'csv'
    author, quote = CSV.read('./data/quotes.csv').sample
    author = "Anonymous" if author == ""
    event.respond ">>> #{quote} *- #{author}*"
end

$bot.message(start_with: PREFIX + 'sadcat') do |event|
    event.respond File.readlines('./data/sadcats.txt').sample
end

$bot.message(start_with: PREFIX + 'aesthetic') do |event|
    event.respond File.readlines('./data/aesthetic.txt').sample
end

$bot.message(start_with: PREFIX + 'prompt') do |event|
    args = event.content.split(" ")
    return unless args.shift == PREFIX + 'prompt'
    if args.empty?
        event.respond format_standard(File.readlines('./data/prompts.txt').sample) 
    else
        command = args.shift
        text = args.join(' ')
        if (command == "add") && (text != '')
            File.open('./data/prompts.txt', 'a') { |f| f.write(text) }
            event.respond format_success("Added prompt!")
        else
            event.respond format_usage("prompt add <text>")
        end
    end
end

$bot.message(start_with: PREFIX + 'phyllotaxis') do |event|
    args = event.content.split(" ")
    return unless args.shift == PREFIX + 'phyllotaxis'
    alpha, scale = args.length == 2 ? [args[0].to_f, args[1].to_f] : [135.5, 2.3]
    event.respond "α = #{alpha}; c = #{scale}"
    event.send_file(File.open(phyllotaxis_png(alpha, scale), 'r'))
end