require 'sinatra'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/' do
    # Category.create(name: "Manufacturing")
    data = Category.all
    data.to_json
  end

  post '/api/v1/businesses' do
    business = Business.create(
      name: params[:name],
      image_url: params[:image_url],
      description: params[:description],
      category_id: params[:category_id],
      services: params[:services]
    )
    business.to_json
  end

  get '/api/v1/businesses' do
    businesses = Business.all
    businesses.to_json
  end

  post '/api/v1/users' do
    user = User.create(
      first_name: params[:first_name],
      last_name: params[:last_name],
      photo_url: params[:photo_url],
      email: params[:email],
      password: params[:password]
    )
    user.to_json
  end

  post '/api/v1/users/:user_id' do
    user = User.find_by_id(params[:user_id])
    if user
      user.to_json
    else
      {"success": false}.to_json
    end
  end

  get '/api/v1/users/:user_id/reviews' do
    user = User.find_by_id(params[:user_id])
    user.reviews.to_json
  end

  post '/api/v1/businesses/:business_id' do
    review = Review.create(
      comment: params[:comment],
      rate: params[:rate],
      user_id: params[:user_id],
      business_id: params[:business_id]
    )
    review.to_json
  end

  get '/api/v1/businesses/:business_id/reviews' do
    business = Business.find_by_id(params[:business_id])
    business.users.to_json
  end
  
end