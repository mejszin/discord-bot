class ChangelogController
    attr_accessor :changelogs

    def initialize(data)
        @changelogs = {}
        data.each do |key, list| 
            @changelogs[key] = list.map.with_index do |changelog_data, index|
                Changelog.new(index + 1, changelog_data)
            end
        end
    end

    def category?(category)
        return @changelogs.key?(category)
    end

    def add_category(category)
        return false if category?(category)
        @changelogs[category] = []
        return true
    end

    def remove_category(category)
        return false unless category?(category)
        @changelogs.delete(category)
        return true
    end
    
    def find_changelog(category, index)
        return nil unless category?(category)
        @changelogs[category].each { |changelog| return changelog if changelog.index?(index) }
        return nil
    end

    def add_changelog(category, text, date = Date.today)
        return false unless category?(category)
        index = @changelogs[category].length
        data = { "text" => text, "date" => date }
        @changelogs[category] << Changelog.new(index, data)
        return true
    end
    
    def remove_changelog(category, index = nil)
        changelog = find_changelog(category, index)
        return false if changelog == nil
        @changelogs[category] -= [changelog]
        return true
    end
    
    def to_json
        hash = {}
        for category, changelogs in @changelogs do
            hash[category] = changelogs.map { |changelog| changelog.to_json }
        end
        return hash
    end
end

class Changelog
    attr_accessor :index, :text
    
    def initialize(index, data)
        @index = index
        @text, @datetime = data["text"], data["datetime"]
    end

    def index?(index)
        return (@index.to_s == index.to_s)
    end

    def set_text(text)
        @text = text
        return true
    end

    def to_json
        return {
            "text" => @text,
            "datetime" => @datetime
        }
    end
end