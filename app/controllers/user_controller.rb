class UserController < ApplicationController


  before_action :authorize_request, except: [:create, :login]

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
      token = ApplicationController.encode(user)
      render json: {user_cost: user.user_cost, first_name: user.first_name, token: token}, status: :ok
    else 
      render json: {error: true, message: 'Invalid Username and/or Password'}, status: :unprocessable_entity 
    end

  end

  def show
    render json: @current_user, status: :ok
  end

  def generalstats
    render json: @current_user.indicators, status: :ok
  end

  def updatecost
    
    if @current_user.update(user_cost: params[:user_cost])
      render json: @current_user, status: :ok
    else
      render json: {error: true, message: 'Unable to update user cost'}, status: 400
    end

  end

end
