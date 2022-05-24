$bot.message(start_with: PREFIX + 'automeds') do |event|
    for issue in redmine_issues('7') do
        event.respond format_standard(issue)
    end
end

$bot.message(start_with: PREFIX + 'emarv3') do |event|
    for issue in redmine_issues('9') do
        event.respond format_standard(issue)
    end
end