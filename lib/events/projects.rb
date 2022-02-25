$bot.message(start_with: '~projects') do |event|
    args = event.content.split(" ")
    return unless args.shift == "~projects"
    # Display usage if args < 1
    if args.length < 1
        event.respond format_usage("~projects <command>")
        return
    end
    # Assign values from args and event
    server = event.server
    user_id = event.message.user.id.to_s
    is_admin = event.message.author.defined_permission?(:administrator)
    command = args.shift
    # Case command
    begin
        responses = case command
            when "list"      ; projects_list(server, is_admin)
            when "add", "new"; projects_add(user_id, args.shift, args.shift, args.join(" "))
            when "join"      ; projects_join(user_id, *args)
            when "leave"     ; projects_leave(user_id, *args)
            when "enable"    ; projects_enable(user_id, *args)
            when "disable"   ; projects_disable(user_id, *args)
            else; format_error("Unknown projects command \"#{command}\"")
        end
         if responses.is_a?(Array)
            responses.each { |response| event.respond response }
        else
            event.respond responses
        end
    rescue => e
        puts e.message
        puts e.backtrace
        event.respond format_error("Invalid command!")
    end
end

def projects_list(server, is_admin = false)
    responses = []
    for project in ProjectController.new.projects do
        if project.active? || is_admin
            message = ["= #{project.title} ="]
            message << "Owner   :: #{project.owner_name(server)}"
            message << "URL     :: #{project.url}"
            message << "Desc    :: #{project.desc}"
            message << "Members :: #{project.member_names(server).join(", ")}"
            message << "Status  :: #{project.status ? "Enabled" : "Disabled"}" if is_admin
            responses << ["```asciidoc", message, "```"].flatten.join("\n")
        end
    end
    return responses
end

def projects_add(user_id, project_title = nil, url = nil, description = '')
    return format_usage("~projects new <project> <url> <description>") if (project_title == nil || url == nil || description == '')
    result = ProjectController.new.add_project(user_id, project_title, description, url)
    return result ? format_success("Created project!") : format_error("Could not create project!")
end

def projects_join(user_id, project_title = nil)
    return format_usage("~projects join <project>") if project_title == nil
    result = ProjectController.new.add_project_member(user_id, project_title)
    return result ? format_success("Joined project!") : format_error("Could not join project!")
end

def projects_leave(user_id, project_title = nil)
    return format_usage("~projects leave <project>") if project_title == nil
    result = ProjectController.new.remove_project_member(user_id, project_title)
    return result ? format_success("Left project!") : format_error("Could not leave project!")
end

def projects_enable(user_id, project_title = nil)
    return format_usage("~projects enable <project>") if project_title == nil
    result = ProjectController.new.set_project_status(user_id, project_title, true)
    return result ? format_success("Enabled project!") : format_error("Could not enable project!")
end

def projects_disable(user_id, project_title = nil)
    return format_usage("~projects disable <project>") if project_title == nil
    result = ProjectController.new.set_project_status(user_id, project_title, false)
    return result ? format_success("Disabled project!") : format_error("Could not disable project!")
end

$bot.message(start_with: '~project-add') do |event|
    words = event.content.split(" ")
    if words.length > 2
        owner, url, title, desc = event.message.user.id.to_s, words[1], words[2], words[3..-1].join(" ")
        result = ProjectController.new.add_project(owner, title, desc, url)
        event.respond result ? format_success("Added project!") : format_error("Could not add project!")
    else
        event.respond format_usage("~project-add <url> <title (no spaces)> <description>")
    end
end
