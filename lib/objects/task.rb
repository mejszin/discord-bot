# CHECKED_BOX = ":negative_squared_cross_mark:"
# UNCHECKED_BOX = ":green_square:"

CHECKED_BOX = "<:checked:946388166313652264>"
UNCHECKED_BOX = "<:unchecked:946388178309373952>"

class Task
    attr_accessor :index, :text
    
    def initialize(index, data)
        @index = index
        @text, @complete = data["text"], data["complete"]
    end

    def index?(index)
        return (@index.to_s == index.to_s)
    end

    def complete?
        return @complete
    end

    def complete
        @complete = true
        return true
    end

    def set_text(text)
        @text = text
        return true
    end

    def checkbox
        return @complete ? CHECKED_BOX : UNCHECKED_BOX
    end

    def to_json
        return {
            "text" => @text,
            "complete" => @complete
        }
    end
end