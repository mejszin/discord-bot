$bot.message(start_with: '~projects') do |event|
    message = []
    for project in ProjectController.new.projects do
        if project.active?
            message = ["= #{project.title} ="]
            message << "Owner   :: #{project.owner_name(event.server)}"
            message << "URL     :: #{project.url}"
            message << "Desc    :: #{project.desc}"
            message << "Members :: #{project.member_names(event.server).join(", ")}"
            event.respond ["```asciidoc", message, "```"].flatten.join("\n")
        end
    end
end


$bot.message(start_with: '~project-task-progress') do |event|
    words = event.content.split(" ")
    if words.length == 2
        project = ProjectController.new.find_project(words[1])
        if (project != nil) && project.active?
            message = []
            # Progress bars
            progress_bar = project.task_controller.progress_bar
            percent = project.task_controller.percent_complete.to_s.rjust(2, " ") + " %"
            message << "all".ljust(16, " ") + progress_bar + " " + percent
            for category, tasks in project.task_controller.tasks do
                progress_bar = project.task_controller.progress_bar(category)
                percent = project.task_controller.percent_complete(category).to_s.rjust(2, " ") + " %"
                message << category.ljust(16, " ") + progress_bar + " " + percent
            end
            event.respond ["```", message, "```"].flatten.join("\n")
        else
            event.respond "``Could not find project!``"
        end
        #result = ProjectController.new.add_project(owner, title, desc, url)
        #event.respond result ? "``Added project!``" : "``Could not add project!``"
    else
        event.respond "Command usage: ``~project-task-progress <title>``"
    end
end

$bot.message(start_with: '~project-tasks') do |event|
    words = event.content.split(" ")
    if words.length == 2
        project = ProjectController.new.find_project(words[1])
        if (project != nil) && project.active?
            # Task list
            for category, tasks in project.task_controller.tasks do
                message = ["**#{category} tasks:**"]
                for task in tasks do
                    message << "#{task.checkbox} ``#{task.index}`` #{task.desc}"
                end
                event.respond message.flatten.join("\n")
            end
        else
            event.respond "``Could not find project!``"
        end
        #result = ProjectController.new.add_project(owner, title, desc, url)
        #event.respond result ? "``Added project!``" : "``Could not add project!``"
    else
        event.respond "Command usage: ``~project-tasks <title>``"
    end
end

$bot.message(start_with: '~project-task-category-add') do |event|
    words = event.content.split(" ")
    if words.length == 3
        user_id, title, category = event.message.user.id.to_s, words[1], words[2]
        result = ProjectController.new.add_task_category(user_id, title, category)
        event.respond result ? "``Added task category!``" : "``Could not add task category!``"
    else
        event.respond "Command usage: ``~project-task-category-add <title> <category>``"
    end
end

$bot.message(start_with: '~project-task-add') do |event|
    words = event.content.split(" ")
    if words.length > 3
        user_id, title, category, desc = event.message.user.id.to_s, words[1], words[2], words[3..-1].join(" ")
        result = ProjectController.new.add_task(user_id, title, category, desc)
        event.respond result ? "``Added task!``" : "``Could not add task!``"
    else
        event.respond "Command usage: ``~project-task-add <title> <category> <desc>``"
    end
end

$bot.message(start_with: '~project-task-remove') do |event|
    words = event.content.split(" ")
    if words.length == 4
        user_id, title, category, index = event.message.user.id.to_s, words[1], words[2], words[3]
        result = ProjectController.new.remove_task(user_id, title, category, index)
        event.respond result ? "``Removed task!``" : "``Could not remove task!``"
    else
        event.respond "Command usage: ``~project-task-remove <title> <category> <index>``"
    end
end

$bot.message(start_with: '~project-task-complete') do |event|
    words = event.content.split(" ")
    if words.length == 4
        user_id, title, category, index = event.message.user.id.to_s, words[1], words[2], words[3]
        result = ProjectController.new.complete_task(user_id, title, category, index)
        event.respond result ? "``Completed task!``" : "``Could not complete task!``"
    else
        event.respond "Command usage: ``~project-task-complete <title> <category> <index>``"
    end
end

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