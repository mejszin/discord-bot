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
        return false if category?(category)
        @tasks[category] = []
        return true
    end

    def add_task(category, desc)
        return false unless category?(category)
        index = @tasks[category].length
        data = { "desc" => desc, "complete" => false }
        @tasks[category] << Task.new(index, data)
        return true
    end

    def percent_complete(category = nil)
        unless category == nil
            count = @tasks[category].count { |task| task.complete }
            total = @tasks[category].length
        else
            count = @tasks.map { |cat, tasks| tasks.count { |task| task.complete } }.sum
            total = @tasks.map { |cat, tasks| tasks.length }.sum
        end
        return ((count.to_f / total.to_f) * 100).round
    end

    def progress_bar(category = nil)
        percent, fidelity = percent_complete(category), 20
        segments = (percent * (fidelity.to_f / 100)).floor
        return "[" + ("#" * segments) + (" " * (fidelity - segments)) + "]"
    end

    def to_json
        hash = {}
        for category, tasks in @tasks do
            hash[category] = tasks.map { |task| task.to_json }
        end
        return hash
    end
end