BOT_PATH = './lib/bot.rb'
KEYS = ["./discord_token", "./discord_client_id", "./spotify_client_id", "./spotify_client_secret"]

def check_keys
    for key in KEYS do
        unless File.file?(key)
            puts "Missing #{key}..."
            return false
        end
    end
    return true
end

task :run do
    puts system("ruby #{BOT_PATH}") if check_keys
end

task :spotify_test do
    require 'bundler'
    Bundler.setup(:default, :ci)
    require 'rspotify' # https://www.rubydoc.info/github/guilhermesad/rspotify/
    
    SPOTIFY_CLIENT_ID = File.read('./spotify_client_id')
    SPOTIFY_CLIENT_SECRET = File.read('./spotify_client_secret')

    require './lib/api/spotify.rb'

    puts build_spotify_track_message("slenderbodies anemone")
end