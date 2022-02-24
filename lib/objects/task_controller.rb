class Task
    attr_accessor :index, :desc, :complete
    
    def initialize(index, data)
        @index = index
        @desc, @complete = data["desc"], data["complete"]
    end
end

class TaskController
    attr_accessor :tasks

    def initialize(data)
        @tasks = {}
        data.each do |key, list| 
            @tasks[key] = list.map.with_index do |task_data, index|
                Task.new(index + 1, task_data)
            end
        end
    end
end