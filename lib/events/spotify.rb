$bot.message(start_with: '~spotify') do |event|
    words = event.content.split(" ")
    if words.first == "~spotify"
        if words.length > 1
            event.respond build_spotify_track_message(words[1..-1].join(" "))
            event.message.delete
        else
            event.respond "Command usage: ``~spotify <query|url>``"
        end
    end
end

$bot.message(start_with: '~spotify-info') do |event|
    words = event.content.split(" ")
    if words.length > 1
        event.respond build_spotify_info_message(words[1..-1].join(" "))
        event.message.delete
    else
        event.respond "Command usage: ``~spotify-info ~spotify <query|url>``"
    end
end

$bot.message(start_with: '~spotify-genres') do |event|
    words = event.content.split(" ")
    if words.length == 1
        event.respond build_spotify_genres()
    else
        event.respond "Command usage: ``~spotify-genres``"
    end
end

$bot.message(start_with: '~spotify-suggest') do |event|
    words = event.content.split(" ")
    if words.length > 1
        event.respond build_spotify_suggestions(words[1..-1])
    else
        event.respond "Command usage: ``~spotify-suggest <genres>``"
    end
end

$bot.message(start_with: '~spotify-gamut') do |event|
    event.respond EMOTION_GAMUT.join(" ")
end