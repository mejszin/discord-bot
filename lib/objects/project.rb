class Project
    attr_accessor :owner, :title, :url, :description, :status, :members, :task_controller

    def initialize(data)
        # Ingest values from data
        @owner, @title, @description, @url = data["owner"], data["title"], data["description"], data["url"]
        # Default status to true if not given
        @status = data.key?("status") ? data["status"] : true
        # Default members to just owner if not given
        @members = data.key?("members") ? data["members"] : [@owner]
        # Default building task controller with an empty hash if not given
        @task_controller = TaskController.new(data.key?("tasks") ? data["tasks"] : {})
    end

    def active?
        return status
    end

    def has_tasks?
        return @task_controller.tasks != {}
    end

    def owner_name(server)
        user = server.member(@owner)
        return user == nil ? @owner : user.name
    end

    # :green_circle: :white_circle: 

    STATUS_ICONS = {
        :offline => "○",
        :idle => "○",
        :online => "●"
    }

    def member_names(server, show_status = true)
        return @members.map do |member|
            user = server.member(member)
            unless user == nil
                icon = STATUS_ICONS[user.on(server).status]
                show_status ? "#{icon} #{user.name}" : user.name
            else
                member
            end
        end
    end

    def add_member(user_id)
        return false if member?(user_id)
        @members << user_id
        return true
    end

    def remove_member(user_id)
        return false if owner?(user_id)
        return false unless member?(user_id)
        @members -= [user_id]
        return true
    end

    def member?(user_id)
        return @members.include?(user_id)
    end

    def owner?(user_id)
        return @owner == user_id
    end

    def title?(str)
        return @title.upcase == str.upcase
    end

    def set_status(status)
        @status = status
        return true
    end

    def add_task_category(category)
        return @task_controller.add_category(category)
    end

    def remove_task_category(category)
        return @task_controller.remove_category(category)
    end

    def add_task(category, text)
        return @task_controller.add_task(category, text)
    end

    def remove_task(category, index = nil)
        return @task_controller.remove_task(category, index)
    end

    def overwrite_task(category, index, text)
        return @task_controller.overwrite_task(category, index, text)
    end

    def complete_task(category, index)
        return @task_controller.complete_task(category, index)
    end

    def to_json
        return {
            "owner" => @owner,
            "title" => @title,
            "description" => @description,
            "url" => @url,
            "status" => @status,
            "members" => @members,
            "tasks" => @task_controller.to_json
        }
    end
end