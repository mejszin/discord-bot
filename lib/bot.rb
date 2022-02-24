require 'bundler'
Bundler.setup(:default, :ci)

require 'rest-client'
require 'discordrb' # https://www.rubydoc.info/gems/discordrb/3.2.1/
require 'rspotify' # https://www.rubydoc.info/github/guilhermesad/rspotify/

require './lib/api/spotify.rb'
require './lib/objects/task.rb'
require './lib/objects/task_controller.rb'
require './lib/objects/project.rb'
require './lib/objects/project_controller.rb'

DISCORD_TOKEN = File.read('./discord_token')
DISCORD_CLIENT_ID = File.read('./discord_client_id')
SPOTIFY_CLIENT_ID = File.read('./spotify_client_id')
SPOTIFY_CLIENT_SECRET = File.read('./spotify_client_secret')

puts "DISCORD_TOKEN=#{DISCORD_TOKEN}"
puts "DISCORD_CLIENT_ID=#{DISCORD_CLIENT_ID}"
puts "SPOTIFY_CLIENT_ID=#{SPOTIFY_CLIENT_ID}"
puts "SPOTIFY_CLIENT_SECRET=#{SPOTIFY_CLIENT_SECRET}"

$bot = Discordrb::Bot.new(token: DISCORD_TOKEN, client_id: DISCORD_CLIENT_ID)

require './lib/events/help.rb'
require './lib/events/projects.rb'
require './lib/events/spotify.rb'
require './lib/events/miscellaneous.rb'

$bot.message(start_with: '~test') do |event|
    user_id = event.message.user.id
    event.respond event.server.member(user_id).name
end

$bot.run