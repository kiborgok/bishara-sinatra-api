require 'sinatra'
require_relative "./config/environment"

class App < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/' do
    Category.create(name: "Manufacturing")
    data = Category.all
    data.to_json
  end
  
end

run App
