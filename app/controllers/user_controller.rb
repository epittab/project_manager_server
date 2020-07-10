class UserController < ApplicationController
  def create
    
    user = User.new(first_name: params[:first_name], last_name: params[:last_name],  username: params[:username], password: params[:password])
    if (user.save)
      render json: {user_id: user.id, first_name: user.first_name, token: {}}, status: :ok
    else 
      render json: {error: true, message: user.error}, status: :unprocessable_entity 
    end
    
  end

  def login

    user = User.find_by(username: params[:username]).try(:authenticate, params[:password])
    
    if (user)
      render json: {user_id: user.id, first_name: user.first_name, token: {}}, status: :ok
    else 
      render json: {error: true, message: 'Invalid Username and/or Password'}, status: :unprocessable_entity 
    end

  end




end
