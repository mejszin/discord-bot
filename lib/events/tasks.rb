$bot.message(start_with: PREFIX + 'tasks') do |event|
    args = event.content.split(" ")
    return unless args.shift == PREFIX + "tasks"
    # Display usage if args < 2
    if args.length < 2
        event.respond format_usage("tasks <project> <command>")
        return
    end
    # Assign values from args and event
    user_id = event.message.user.id.to_s
    project = args.shift
    command = args.shift
    # Case command
    begin
        case command
            when "list"           ; event.respond tasks_list(project, args)
        #   when "progress"       ; event.respond tasks_progress(project)
            when "add-category"   ; event.respond tasks_category_add(user_id, project, *args)
            when "remove-category"; event.respond tasks_category_remove(user_id, project, *args)
            when "clear-category" ; event.respond tasks_category_clear(user_id, project, *args)
            when "add"            ; event.respond tasks_add(user_id, project, args.shift, args.join(" "))
            when "remove"         ; event.respond tasks_remove(user_id, project, *args)
            when "overwrite"      ; event.respond tasks_overwrite(user_id, project, args.shift, args.shift, args.join(" "))
            when "complete"       ; event.respond tasks_complete(user_id, project, *args)
            when "progress"
                response = tasks_progress_image(project)
                File.file?(response) ? event.send_file(File.open(response, 'r')) : event.respond(response)
            else; format_error("Unknown tasks command \"#{command}\"")
        end
    rescue => e
        puts e.message
        puts e.backtrace
        event.respond format_error("Invalid command!")
    end
end

def tasks_list(project_title, categories = [])
    project = ProjectController.new.find_project(project_title)
    if (project != nil) && project.active?
        if project.has_tasks?
            # Task list
            message = []
            for category, tasks in project.task_controller.tasks do
                if (categories == []) or (categories.include?(category))
                    message << "**``#{category}``**"
                    for task in tasks do
                        message << "#{task.checkbox} ``#{task.index}`` #{task.text}"
                    end
                end
            end
            return message.flatten.join("\n")
        else
            return format_standard("This project has no tasks!")
        end
    else
        return format_error("Could not find project!")
    end
end

def tasks_progress(project_title)
    project = ProjectController.new.find_project(project_title)
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
        return ["```", message, "```"].flatten.join("\n")
    else
        return format_error("Could not find project!")
    end
end

def tasks_progress_image(project_title)
    project = ProjectController.new.find_project(project_title)
    if (project != nil) && project.active?
        message = []
        # Progress bars
        percentages = []
        percentages << ["ALL", *project.task_controller.complete_total]
        for category, tasks in project.task_controller.tasks do
            percentages << [category.upcase, *project.task_controller.complete_total(category)]
        end
        return bar_graph_png(percentages)
    else
        return format_error("Could not find project!")
    end
end

def tasks_category_add(user_id, project_title, category = nil)
    return format_usage("tasks <project> add-category <category>") if category == nil
    result = ProjectController.new.add_task_category(user_id, project_title, category)
    return result ? format_success("Added task category!") : format_error("Could not add task category!")
end

def tasks_category_remove(user_id, project_title, category = nil)
    return format_usage("tasks <project> remove-category <category>") if category == nil
    result = ProjectController.new.remove_task_category(user_id, project_title, category)
    return result ? format_success("Removed task category!") : format_error("Could not remove task category!")
end

def tasks_category_clear(user_id, project_title, category = nil)
    return format_usage("tasks <project> clear-category <category>") if category == nil
    result = ProjectController.new.remove_task(user_id, project_title, category)
    return result ? format_success("Cleared task category!") : format_error("Could not clear task category!")
end

def tasks_add(user_id, project_title, category = nil, text = '')
    return format_usage("tasks <project> add <category> <text>") if ((category == nil) || (text == ''))
    result = ProjectController.new.add_task(user_id, project_title, category, text)
    return result ? format_success("Added task!") : format_error("Could not add task!")
end

def tasks_remove(user_id, project_title, category = nil, index = nil)
    return format_usage("tasks <project> remove <category> <index>") if ((category == nil) || (index == nil))
    result = ProjectController.new.remove_task(user_id, project_title, category, index)
    return result ? format_success("Removed task!") : format_error("Could not remove task!")
end

def tasks_overwrite(user_id, project_title, category = nil, index = nil, text = '')
    return format_usage("tasks <project> overwrite <category> <index> <text>") if ((category == nil) || (index == nil) || (text == ''))
    result = ProjectController.new.overwrite_task(user_id, project_title, category, index, text)
    return result ? format_success("Overwritten task!") : format_error("Could not overwrite task!")
end

def tasks_complete(user_id, project_title, category = nil, index = nil)
    return format_usage("tasks <project> complete <category> <index>") if ((category == nil) || (index == nil))
    result = ProjectController.new.complete_task(user_id, project_title, category, index)
    return result ? format_success("Completed task!") : format_error("Could not complete task!")
end