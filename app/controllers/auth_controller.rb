class AuthController < ApplicationController

    before_action :authorize_request

    def check_user_status
        render json: @current_user
    end
end
