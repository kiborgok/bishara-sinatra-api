require 'sinatra'
require_relative "./config/environment"

class App < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/' do
    data = Game.all
    data.to_json
    # {message: "hello"}.to_json
  end
  
end

run App
