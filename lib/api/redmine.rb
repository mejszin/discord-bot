REDMINE_URL = ''
REDMINE_API_KEY = ''

def redmine_issues(project_id = '9')
    url = "#{REDMINE_URL}/issues.json?key=#{REDMINE_API_KEY}&project_id=#{project_id}"
    response = Faraday.get(url)
    if response.status == 200
        json = JSON.parse(response.body)
        return json["issues"].map { |issue| issue["subject"] }
    else
        return []
    end
end

# redmine_issues