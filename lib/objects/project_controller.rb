class ProjectController
    attr_reader :projects

    def initialize(path = './data/projects.json')
        @path = path
        @projects = read_from_file
    end

    def read_from_file
        require 'json'
        file = File.open(@path, encoding: "UTF-8")
        json = JSON.load(file)
        file.close
        return json.map { |data| Project.new(data) }
    end

    def write_to_file
        arr = @projects.map { |project| project.to_json }
        File.open(@path, "w", encoding: "UTF-8") do |file|
            file.puts arr.to_json
        end
    end

    def export_project(user_id, title, is_admin = false)
        require 'json'
        project = find_project(title)
        return nil if project == nil
        return nil unless (project.owner?(user_id) || is_admin)
        return JSON.pretty_generate(project.to_json)
    end

    def find_project(title)
        @projects.each { |project| return project if project.title?(title) }
        return nil
    end

    def add_project(owner, title, description, url)
        data = { "owner" => owner, "title" => title, "description" => description, "url" => url }
        @projects << Project.new(data)
        write_to_file
        return true
    end

    def set_project_description(user_id, title, description)
        project = find_project(title)
        return false if project == nil
        return false unless project.owner?(user_id)
        result = project.set_description(description)
        write_to_file if result == true
        return result
    end

    def add_project_member(user_id, title)
        project = find_project(title)
        return false if project == nil
        result = project.add_member(user_id)
        write_to_file if result == true
        return result
    end

    def remove_project_member(user_id, title)
        project = find_project(title)
        return false if project == nil
        result = project.remove_member(user_id)
        write_to_file if result == true
        return result
    end

    def set_project_status(user_id, title, status)
        project = find_project(title)
        return false if project == nil
        return false unless project.owner?(user_id)
        result = project.set_status(status)
        write_to_file if result == true
        return result
    end

    def add_task_category(user_id, title, category)
        project = find_project(title)
        return false if project == nil
        return false unless project.member?(user_id)
        result = project.add_task_category(category)
        write_to_file if result == true
        return result
    end

    def remove_task_category(user_id, title, category)
        project = find_project(title)
        return false if project == nil
        return false unless project.member?(user_id)
        result = project.remove_task_category(category)
        write_to_file if result == true
        return result
    end

    def add_task(user_id, title, category, text)
        project = find_project(title)
        return false if project == nil
        return false unless project.member?(user_id)
        result = project.add_task(category, text)
        write_to_file if result == true
        return result
    end

    def remove_task(user_id, title, category, index = nil)
        project = find_project(title)
        return false if project == nil
        return false unless project.member?(user_id)
        result = project.remove_task(category, index)
        write_to_file if result == true
        return result
    end

    def overwrite_task(user_id, title, category, index, text)
        project = find_project(title)
        return false if project == nil
        return false unless project.member?(user_id)
        result = project.overwrite_task(category, index, text)
        write_to_file if result == true
        return result
    end

    def complete_task(user_id, title, category, index)
        project = find_project(title)
        return false if project == nil
        return false unless project.member?(user_id)
        result = project.complete_task(category, index)
        write_to_file if result == true
        return result
    end
end

# projects = Projects.new
# projects.set_project_status("472499883035852801", "haedi", false)
# projects.write_to_file