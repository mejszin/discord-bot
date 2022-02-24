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

    def find_project(title)
        @projects.each { |project| return project if project.title?(title) }
        return nil
    end

    def add_project(owner, title, desc, url)
        data = { "owner" => owner, "title" => title, "desc" => desc, "url" => url }
        @projects << Project.new(data)
        write_to_file
    end

    def add_project_member(user_id, title)
        project = find_project(title)
        return false if project == nil
        return project.add_member(user_id)
    end

    def remove_project_member(user_id, title)
        project = find_project(title)
        return false if project == nil
        return project.remove_member(user_id)
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

    def add_task(user_id, title, category, desc)
        project = find_project(title)
        return false if project == nil
        return false unless project.member?(user_id)
        result = project.add_task(category, desc)
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