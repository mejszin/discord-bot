class Projects
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
            if (title == project.title)
                return false if project.members.include?(user_id)
                project.members << user_id
                write_to_file
                return true
            end
        end
        return false
    end

    def remove_project_member(user_id, title)
        for project in @projects do
            if (title == project.title)
                return false if user_id == project.owner
                return false unless project.members.include?(user_id)
                project.members -= [user_id]
                write_to_file
                return true
            end
        end
        return false
    end

    def set_project_status(user_id, title, status)
        for project in @projects do
            if (user_id == project.owner) && (title == project.title)
                project.status = status
                write_to_file
                return true
            end
        end
        return false
    end
end

# projects = Projects.new
# projects.set_project_status("472499883035852801", "haedi", false)
# projects.write_to_file