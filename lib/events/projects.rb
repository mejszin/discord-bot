$bot.message(start_with: '~projects') do |event|
    message = []
    is_admin = event.message.author.defined_permission?(:administrator)
    for project in ProjectController.new.projects do
        if project.active? || is_admin
            message = ["= #{project.title} ="]
            message << "Owner   :: #{project.owner_name(event.server)}"
            message << "URL     :: #{project.url}"
            message << "Desc    :: #{project.desc}"
            message << "Members :: #{project.member_names(event.server).join(", ")}"
            message << "Status  :: #{project.status ? "Enabled" : "Disabled"}" if is_admin
            event.respond ["```asciidoc", message, "```"].flatten.join("\n")
        end
    end
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

$bot.message(start_with: '~project-join') do |event|
    words = event.content.split(" ")
    if words.length == 2
        result = ProjectController.new.add_project_member(event.message.user.id.to_s, words[1])
        event.respond result ? format_success("Joined project!") : format_error("Could not join project!")
    else
        event.respond format_usage("~project-join <title>")
    end
end

$bot.message(start_with: '~project-leave') do |event|
    words = event.content.split(" ")
    if words.length == 2
        result = ProjectController.new.remove_project_member(event.message.user.id.to_s, words[1])
        event.respond result ? format_success("Left project!") : format_error("Could not leave project!")
    else
        event.respond format_usage("~project-leave <title>")
    end
end

$bot.message(start_with: '~project-enable') do |event|
    words = event.content.split(" ")
    if words.length == 2
        result = ProjectController.new.set_project_status(event.message.user.id.to_s, words[1], true)
        event.respond result ? format_success("Enabled project!") : format_error("Could not enable project!")
    else
        event.respond format_usage("~project-enable <title>")
    end
end

$bot.message(start_with: '~project-disable') do |event|
    words = event.content.split(" ")
    if words.length == 2
        result = ProjectController.new.set_project_status(event.message.user.id.to_s, words[1], false)
        event.respond result ? format_success("Disabled project!") : format_error("Could not disable project!")
    else
        event.respond format_usage("~project-disable <title>")
    end
end