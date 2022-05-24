url = "https://discord.com/api/v8/applications/#{DISCORD_CLIENT_ID}/commands"

headers = { 
    "Content-Type" => "application/json",
    "Authorization" => "Bot #{DISCORD_TOKEN}"
}

body = {
    "name" => "quote",
    "type" => 3,
    "description" => "Send a random inspirational quote"
}.to_json

connection = Faraday.new(url: 'https://discord.com')

path = "/api/v8/applications/#{DISCORD_CLIENT_ID}/commands"

response = connection.run_request(:post, path, body, headers)

# response = connection.run_request(:get, path, nil, headers)

puts response.body