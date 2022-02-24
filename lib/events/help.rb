$bot.message(start_with: '~help') do |event|
    message = File.readlines("./usage.txt").map { |line| line.chomp }
    event.respond ["```markdown", message, "```"].flatten.join("\n")
    event.message.delete
end