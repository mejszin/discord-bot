class Project
    attr_accessor :owner, :title, :url, :desc, :status, :members
    def initialize(data)
        @owner, @title, @desc, @url = data["owner"], data["title"], data["desc"], data["url"]
        @status = data.key?("status") ? data["status"] : true
        @members = data.key?("members") ? data["members"] : [@owner]
    end

    def active
        return status
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
            "owner" => @owner, "title" => @title, "desc" => @desc,
            "url" => @url, "status" => @status, "members" => @members
        }
    end
end