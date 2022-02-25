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

task :bg do
    system("ruby #{BOT_PATH} &") if check_keys
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
        if project.has_tasks?
            puts "Project #{project.title}:\n\n"
            for category, tasks in project.task_controller.tasks do
                percent = project.task_controller.percent_complete(category)
                progress_bar = project.task_controller.progress_bar(category)
                puts "  #{category} tasks:\n\n  #{progress_bar} (#{percent}%)\n\n"
                for task in tasks do
                    puts "  #{task.complete ? "[X]" : "[ ]"} (#{task.index}) #{category} - #{task.desc}"
                end
                puts "\n"
            end
        end
    end
end
