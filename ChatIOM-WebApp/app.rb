# app.rb
require 'sinatra'
require 'net/http'
require 'json'

# Route for the chatbox
get '/' do
  erb :index
end

# Route to handle form submission
post '/chat' do
  user_input = params[:message]
  uri = URI('https://chatiom-community.manx.ai/v1/chat/completions')

  # Prepare the request
  request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
  request.body = {  messages: [{ role: "user", content: user_input }] }.to_json

  # Send the request
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  # Parse and display the response
  @response_message = JSON.parse(response.body)["choices"].first["message"]["content"]
  erb :index
end
