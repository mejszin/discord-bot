$bot.message(start_with: PREFIX + 'changelog') do |event|
    args = event.content.split(" ")
    return unless args.shift == PREFIX + "changelog"
    # Display usage if args < 2
    if args.length < 2
        event.respond format_usage("changelog <project> <command>")
        return
    end
    # Assign values from args and event
    user_id = event.message.user.id.to_s
    project = args.shift
    command = args.shift
    # Case command
    begin
        event.respond case command
            when "list"           ; changelog_list(project, args)
            when "add-category"   ; changelog_category_add(user_id, project, *args)
            when "remove-category"; changelog_category_remove(user_id, project, *args)
            when "add"            ; changelog_add(user_id, project, args.shift, args.join(" "))
            when "remove"         ; changelog_remove(user_id, project, *args)
            else; format_error("Unknown changelog command \"#{command}\"")
        end
    rescue => e
        puts e.message
        puts e.backtrace
        event.respond format_error("Invalid command!")
    end
end

def changelog_add(user_id, project_title, category = nil, text = '')
    return format_usage("changelog <project> add <category> <text>") if ((category == nil) || (text == ''))
    result = ProjectController.new.add_changelog(user_id, project_title, category, text)
    return result ? format_success("Added changelog!") : format_error("Could not add changelog!")
end

def changelog_remove(user_id, project_title, category = nil, index = nil)
    return format_usage("changelog <project> remove <category> <index>") if ((category == nil) || (index == nil))
    result = ProjectController.new.remove_changelog(user_id, project_title, category, index)
    return result ? format_success("Removed changelog!") : format_error("Could not remove changelog!")
end

def changelog_category_add(user_id, project_title, category = nil)
    return format_usage("changelog <project> add-category <category>") if category == nil
    result = ProjectController.new.add_changelog_category(user_id, project_title, category)
    return result ? format_success("Added changelog category!") : format_error("Could not add changelog category!")
end

def changelog_category_remove(user_id, project_title, category = nil)
    return format_usage("changelog <project> remove-category <category>") if category == nil
    result = ProjectController.new.remove_changelog_category(user_id, project_title, category)
    return result ? format_success("Removed changelog category!") : format_error("Could not remove changelog category!")
end

def changelog_list(project_title, categories = [])
    project = ProjectController.new.find_project(project_title)
    if (project != nil) && project.active?
        if project.has_changelogs?
            # Task list
            message = []
            for category, changelogs in project.changelog_controller.changelogs do
                if (categories == []) or (categories.include?(category))
                    message << "**``#{category}``**"
                    for changelog in changelogs do
                        message << "• #{changelog.text}"
                    end
                end
            end
            return message.flatten.join("\n")
        else
            return format_standard("This project has no changelogs!")
        end
    else
        return format_error("Could not find project!")
    end
end