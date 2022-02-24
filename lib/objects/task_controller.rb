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

    def find_task(category, index)
        return nil unless category?(category)
        @tasks[category].each { |task| return task if task.index?(index) }
        return nil
    end

    def category?(category)
        return @tasks.key?(category)
    end

    def add_category(category)
        return false if category?(category)
        @tasks[category] = []
        return true
    end

    def remove_category(category)
        return false unless category?(category)
        @tasks.delete(category)
        return true
    end

    def add_task(category, desc)
        return false unless category?(category)
        index = @tasks[category].length
        data = { "desc" => desc, "complete" => false }
        @tasks[category] << Task.new(index, data)
        return true
    end

    def remove_task(category, index = nil)
        unless index == nil
            task = find_task(category, index)
            return false if task == nil
            @tasks[category] -= [task]
        else
            @tasks[category] = []
        end
        return true
    end

    def complete_task(category, index)
        task = find_task(category, index)
        return false if task == nil
        return task.complete
    end

    def percent_complete(category = nil)
        # Calculate overall percentage complete if no category given
        unless category == nil
            count = @tasks[category].count { |task| task.complete? }
            total = @tasks[category].length
        else
            count = @tasks.map { |cat, tasks| tasks.count { |task| task.complete? } }.sum
            total = @tasks.map { |cat, tasks| tasks.length }.sum
        end
        return ((count.to_f / total.to_f) * 100).round
    end

    # https://changaco.oy.lc/unicode-progress-bars/

    def progress_bar(category = nil)
        # Styling variables
        solid_bar = "▮" # "▰"
        empty_bar = "▯" # "▱"
        bar_padding = ""
        fidelity = 20
        # Build progress bar
        percent = percent_complete(category)
        segments = (percent * (fidelity.to_f / 100)).floor
        return ([solid_bar] * segments + [empty_bar] * (fidelity - segments)).join(bar_padding)
    end

    def to_json
        hash = {}
        for category, tasks in @tasks do
            hash[category] = tasks.map { |task| task.to_json }
        end
        return hash
    end
end