require 'sinatra'
require 'json'

class App < Sinatra::Base

  get '/' do
    user1 = User.create(name: "Alex")
    {name: user1.name}.to_json
  end
  
end

run App
