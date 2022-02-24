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

    def category?(category)
        return @tasks.key?(category)
    end

    def add_category(category)
        @tasks[category] = []
    end

    def percent_complete(category)
        count = @tasks[category].count { |task| task.complete }
        total = @tasks[category].length
        return ((count.to_f / total.to_f) * 100).round
    end

    def progress_bar(category)
        percent, fidelity = percent_complete(category), 20
        segments = (percent * (fidelity.to_f / 100)).floor
        return "[" + ("#" * segments) + (" " * (fidelity - segments)) + "]"
    end

    def to_json
        hash = {}
        for category, tasks in @tasks do
            hash[category] = []
            for task in tasks do
                hash[category] << task.to_json
            end
        end
        return hash
    end
end