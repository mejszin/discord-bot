class Task
    attr_accessor :index, :desc, :complete
    
    def initialize(index, data)
        @index = index
        @desc, @complete = data["desc"], data["complete"]
    end

    def to_json
        return {
            "desc" => @desc,
            "complete" => @complete
        }
    end
end