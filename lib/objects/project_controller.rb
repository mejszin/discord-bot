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

    def add_project(owner, title, desc, url)
        data = { "owner" => owner, "title" => title, "desc" => desc, "url" => url }
        @projects << Project.new(data)
        write_to_file
    end

    def add_project_member(user_id, title)
        for project in @projects do
            return project.add_member(user_id) if project.title?(title)
        end
        return false
    end

    def remove_project_member(user_id, title)
        for project in @projects do
            return project.remove_member(user_id) if project.title?(title)
        end
        return false
    end

    def set_project_status(user_id, title, status)
        for project in @projects do
            return project.set_status(status) if project.owner?(user_id) && project.title?(title)
        end
        return false
    end

    def add_task_category(user_id, title, category)
        for project in @projects do
            if (project.member?(user_id)) && (title == project.title)
                return project.add_task_category(category)
            end
        end
        return false
    end
end

# projects = Projects.new
# projects.set_project_status("472499883035852801", "haedi", false)
# projects.write_to_file