class Task
    attr_accessor :index, :desc, :complete
    
    def initialize(index, data)
        @index = index
        @desc, @complete = data["desc"], data["complete"]
    end
end