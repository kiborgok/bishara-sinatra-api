require 'sinatra'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  enable :sessions

  get '/api/v1/categories' do
    # response.headers['sessions'] = session
    data = Category.all
    data.to_json
  end

  post '/api/v1/categories' do
    data = Category.create(name: params[:name])
    data.to_json
  end

  post '/api/v1/businesses/search' do
    sub_str = params[:search]
    result = Business.where("name LIKE ?", "%" + sub_str + "%")
    result.to_json
  end

  post '/api/v1/businesses' do
    business = Business.create(
      name: params[:name],
      image_url: params[:image_url],
      description: params[:description],
      category_id: params[:category_id],
      services: params[:services],
      rating: params[:rating]
    )
    business.to_json
  end

  get '/api/v1/businesses' do
    businesses = Business.all.collect do |business|
      {
        id: business[:id],
        name: business[:name],
        image_url: business[:image_url],
        description: business[:description],
        category_id: business.category,
        services: business[:services],
        rating: business[:rating],
        reviews: business.reviews
      }
    end
    businesses.to_json
  end

  get '/api/v1/users' do
    data = User.all
    data.to_json
  end

  post '/api/v1/signin' do
    if params[:email].empty? || params[:password].empty?
      return {statusCode: 400, message: "Please fill in all the fields"}.to_json
    else
      user = User.find_by(email: params[:email])
      if !user
        return {statusCode: 400, message: "Account does not exist, Please signup."}.to_json
      end
      if user && user.password != params[:password]
        return {statusCode: 400, message: "Wrong password/email."}.to_json
      end
      payload = {
        userId: user[:id],
        email: user[:email],
        first_name: user[:first_name],
        last_name: user[:last_name],
        photo_url: user[:photo_url]
      }

      token = JWT.encode payload, nil, 'HS256'

      {token: token}.to_json
    end
  end

  post '/api/v1/signup' do
    if params[:first_name].empty? || params[:last_name].empty? || params[:email].empty? || params[:password].empty?
      return {statusCode: 400, message: "Please fill in all the fields"}.to_json
    elsif User.find_by(email: params[:email])
      return {statusCode: 409, message: "User #{params[:email]} already exists."}.to_json
    end
    user = User.create(
      first_name: params[:first_name],
      last_name: params[:last_name],
      photo_url: params[:photo_url],
      email: params[:email],
      password: params[:password]
    )

    payload = {
      userId: user[:id],
      email: user[:email],
      first_name: user[:first_name],
      last_name: user[:last_name],
      photo_url: user[:photo_url]
    }

    token = JWT.encode payload, nil, 'HS256'

    {token: token}.to_json
  end

  patch '/api/v1/users/:user_id' do
    user = User.find_by_id(params[:user_id])
    if params[:first_name].empty? || params[:last_name].empty?
      return {statusCode: 400, message: "First and last name cannot be empty."}
    end
    if !user
      return {statusCode: 404, message: "User not found"}
    end
    if user
      updated_user = user.update(
        photo_url: params[:photo_url],
        first_name: params[:first_name],
        last_name: params[:last_name]
      )
      payload = {
        userId: user[:id],
        email: user[:email],
        first_name: user[:first_name],
        last_name: user[:last_name],
        photo_url: user[:photo_url]
      }

      token = JWT.encode payload, nil, 'HS256'

      {token: token}.to_json
    end
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

  post '/api/v1/reviews/:user_id/:business_id' do
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

  get '/api/v1/reviews' do
    reviews = Review.all()
    reviews.to_json
  end

  # post '/api/v1/reviews' do
  #   review = Review.create(
  #     comment: params[:comment],
  #     rate: params[:rate],
  #     user_id: params[:user_id],
  #     business_id: params[:business_id]
  #   )
  #   review.to_json
  # end

end