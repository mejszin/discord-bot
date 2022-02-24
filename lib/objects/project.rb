class Project
    attr_accessor :owner, :title, :url, :desc, :status, :members, :task_controller

    def initialize(data)
        # Ingest values from data
        @owner, @title, @desc, @url = data["owner"], data["title"], data["desc"], data["url"]
        # Default status to true if not given
        @status = data.key?("status") ? data["status"] : true
        # Default members to just owner if not given
        @members = data.key?("members") ? data["members"] : [@owner]
        # Default building task controller with an empty hash if not given
        @task_controller = TaskController.new(data.key?("tasks") ? data["tasks"] : {})
    end

    def active
        return status
    end

    def has_tasks?
        return @task_controller.tasks != {}
    end

    def owner_name(server)
        user = server.member(@owner)
        return user == nil ? @owner : user.name
    end

    def member_names(server)
        return @members.map do |member|
            user = server.member(member)
            user == nil ? member : user.name
        end
    end

    def to_json
        return {
            "owner" => @owner,
            "title" => @title,
            "desc" => @desc,
            "url" => @url,
            "status" => @status,
            "members" => @members,
            "tasks" => @tasks
        }
    end
end