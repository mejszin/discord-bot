$bot.message(start_with: '~project-add') do |event|
    words = event.content.split(" ")
    if words.length > 2
        owner, url, title, desc = event.message.user.id, words[1], words[2], words[3..-1].join(" ")
        result = ProjectController.new.add_project(owner, title, desc, url)
        event.respond result ? "``Added project!``" : "``Could not add project!``"
    else
        event.respond "Command usage: ``~project-add <url> <title (no spaces)> <description (spaces allowed)>``"
    end
end

$bot.message(start_with: '~project-join') do |event|
    words = event.content.split(" ")
    if words.length == 2
        result = ProjectController.new.add_project_member(event.message.user.id.to_s, words[1])
        event.respond result ? "``Joined project!``" : "``Could not join project!``"
    else
        event.respond "Command usage: ``~project-join <title>``"
    end
end

$bot.message(start_with: '~project-leave') do |event|
    words = event.content.split(" ")
    if words.length == 2
        result = ProjectController.new.remove_project_member(event.message.user.id.to_s, words[1])
        event.respond result ? "``Left project!``" : "``Could not leave project!``"
    else
        event.respond "Command usage: ``~project-leave <title>``"
    end
end

$bot.message(start_with: '~project-enable') do |event|
    words = event.content.split(" ")
    if words.length == 2
        result = ProjectController.new.set_project_status(event.message.user.id.to_s, words[1], true)
        event.respond result ? "``Enabled project!``" : "``Could not enable project!``"
    else
        event.respond "Command usage: ``~project-enable <title>``"
    end
end

$bot.message(start_with: '~project-disable') do |event|
    words = event.content.split(" ")
    if words.length == 2
        result = ProjectController.new.set_project_status(event.message.user.id.to_s, words[1], false)
        event.respond result ? "``Disabled project!``" : "``Could not disable project!``"
    else
        event.respond "Command usage: ``~project-disable <title>``"
    end
end


$bot.message(start_with: '~projects') do |event|
    message = []
    for project in ProjectController.new.projects do
        if project.active
            message << "Owner   : #{project.owner_name(event.server)}"
            message << "Project : #{project.title}"
            message << "URL     : #{project.url}"
            message << "Desc    : #{project.desc}"
            message << "Members : #{project.member_names(event.server).join(", ")}"
            message << ""
        end
    end
    event.respond ["```", message, "```"].flatten.join("\n")
end