$bot.message(start_with: PREFIX + 'projects') do |event|
    args = event.content.split(" ")
    return unless args.shift == PREFIX + "projects"
    # Display usage if args < 1
    if args.length < 1
        event.respond format_usage("projects <command>")
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
            when "list"                ; projects_list(server, is_admin)
            when "add", "new", "create"; projects_add(user_id, args.shift, args.shift, args.join(" "))
            when "description"         ; projects_description(user_id, args.shift, args.join(" "))
            when "website"             ; projects_website(user_id, *args)
            when "join"                ; projects_join(user_id, *args)
            when "leave"               ; projects_leave(user_id, *args)
            when "enable"              ; projects_enable(user_id, *args)
            when "disable"             ; projects_disable(user_id, *args)
            when "export"              ; projects_export(user_id, is_admin, *args)
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
            # Get progress bar with percentage
            percent = project.task_controller.percent_complete.to_s + " %"
            progress_bar = project.task_controller.progress_bar + " " + percent
            # Build message
            message = ["= #{project.title} ="]
            message << "Members     :: #{project.member_names(server).join(", ")}"
            message << "Description :: #{project.description}"
           #message << "Owner   :: #{project.owner_name(server)}"
            message << "Website     :: #{project.url}"
            message << "Progress    :: #{progress_bar}"
           #message << "Status      :: #{project.status ? "Enabled" : "Disabled"}" if is_admin
            responses << ["```asciidoc", message, "```"].flatten.join("\n")
        end
    end
    return responses
end

def projects_export(user_id, is_admin = false, project_title = nil)
    return format_usage("projects export <project>") if project_title == nil
    json = ProjectController.new.export_project(user_id, project_title, is_admin)
    return json != nil ? format_standard(json) : format_error("Could not export project!")
end

def projects_add(user_id, project_title = nil, url = nil, description = '')
    return format_usage("projects create|new|add <project> <url> <description>") if (project_title == nil || url == nil || description == '')
    result = ProjectController.new.add_project(user_id, project_title, description, url)
    return result ? format_success("Created project!") : format_error("Could not create project!")
end

def projects_description(user_id, project_title = nil, description = '')
    return format_usage("projects description <description> <text>") if (project_title == nil || description == '')
    result = ProjectController.new.set_project_description(user_id, project_title, description)
    return result ? format_success("Changed description!") : format_error("Could not change description!")
end

def projects_website(user_id, project_title = nil, url = nil)
    return format_usage("TODO: #{PREFIX}projects website")
    #return format_usage("projects website <url>") if project_title == nil
    #return ProjectController.new.project_url(user_id, project_title, url) if url == nil
    #result = ProjectController.new.set_project_url(user_id, project_title, url)
    #return result ? format_success("Changed URL!") : format_error("Could not change URL!")
end

def projects_join(user_id, project_title = nil)
    return format_usage("projects join <project>") if project_title == nil
    result = ProjectController.new.add_project_member(user_id, project_title)
    return result ? format_success("Joined project!") : format_error("Could not join project!")
end

def projects_leave(user_id, project_title = nil)
    return format_usage("projects leave <project>") if project_title == nil
    result = ProjectController.new.remove_project_member(user_id, project_title)
    return result ? format_success("Left project!") : format_error("Could not leave project!")
end

def projects_enable(user_id, project_title = nil)
    return format_usage("projects enable <project>") if project_title == nil
    result = ProjectController.new.set_project_status(user_id, project_title, true)
    return result ? format_success("Enabled project!") : format_error("Could not enable project!")
end

def projects_disable(user_id, project_title = nil)
    return format_usage("projects disable <project>") if project_title == nil
    result = ProjectController.new.set_project_status(user_id, project_title, false)
    return result ? format_success("Disabled project!") : format_error("Could not disable project!")
end