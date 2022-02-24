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

task :project_test do
    require 'bundler'
    Bundler.setup(:default, :ci)

    require './lib/objects/task.rb'
    require './lib/objects/task_controller.rb'
    require './lib/objects/project.rb'
    require './lib/objects/project_controller.rb'

    projects = ProjectController.new.projects
    
    for project in projects do
        puts project.title if project.has_tasks?
        for category, tasks in project.task_controller.tasks do
            puts project.task_controller.percent_complete(category).to_s + "%"
            puts project.task_controller.progress_bar(category)
            for task in tasks do
                puts "#{task.complete ? "[X]" : "[ ]"} #{category} - #{task.desc}"
            end
        end
    end
end