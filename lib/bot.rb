BOT_NAME = 'La Soleil'
BOT_AVATAR = './data/sunny.png'
PREFIX = '.'

require 'bundler'
Bundler.setup(:default, :ci)

require 'rest-client'
require 'discordrb' # https://www.rubydoc.info/gems/discordrb/3.2.1/
require 'rspotify' # https://www.rubydoc.info/github/guilhermesad/rspotify/
require 'chunky_png'
require 'json'
require 'faraday'

SCOPE = JSON.load(File.read('./scope.json').chomp)

DISCORD_TOKEN = File.read('./discord_token').chomp
DISCORD_CLIENT_ID = File.read('./discord_client_id').chomp
puts "DISCORD_TOKEN=#{DISCORD_TOKEN}"
puts "DISCORD_CLIENT_ID=#{DISCORD_CLIENT_ID}"

if SCOPE["spotify"]
    SPOTIFY_CLIENT_ID = File.read('./spotify_client_id').chomp
    SPOTIFY_CLIENT_SECRET = File.read('./spotify_client_secret').chomp
    puts "SPOTIFY_CLIENT_ID=#{SPOTIFY_CLIENT_ID}"
    puts "SPOTIFY_CLIENT_SECRET=#{SPOTIFY_CLIENT_SECRET}"
end

require './lib/png.rb'
require './lib/api/spotify.rb'
require './lib/api/redmine.rb'
require './lib/objects/task.rb'
require './lib/objects/task_controller.rb'
require './lib/objects/project.rb'
require './lib/objects/project_controller.rb'
require './lib/objects/changelog_controller.rb'

def format_standard(str); return "```\n#{str}\n```"; end
def format_success(str); return "```diff\n+ #{str}\n```"; end
def format_error(str); return "```diff\n- #{str}\n```"; end
def format_usage(str); return "Command usage: ``#{PREFIX}#{str}``"; end
def format_help(str); return "```markdown\n#{str}\n```"; end

$bot = Discordrb::Bot.new(token: DISCORD_TOKEN, client_id: DISCORD_CLIENT_ID)


require './lib/events/help.rb'
require './lib/events/misc.rb'

if SCOPE["projects"]
    require './lib/events/projects.rb' 
    require './lib/events/tasks.rb'
    require './lib/events/changelog.rb'
end

if SCOPE["spotify"]
    require './lib/events/spotify.rb'
end

if SCOPE["redmine"]
    require './lib/events/redmine.rb'
end

$bot.message(start_with: PREFIX + 'init') do |event|
    $bot.profile.username = BOT_NAME
    $bot.profile.avatar = File.open(BOT_AVATAR)
    event.respond format_success('Initialized bot!')
end

$bot.message(start_with: PREFIX + 'test') do |event|
    event.message.user.pm "Test"
end

# require './lib/slash.rb'

$bot.run