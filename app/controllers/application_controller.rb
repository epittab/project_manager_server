class ApplicationController < ActionController::API


    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
            @decoded = ApplicationController.decode(header)[0]
            @current_user = User.find(@decoded['sub'])
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: e.message}, status: :unauthorized
        rescue JWT::DecodeError => e
            render json: {errors: e.message}, status: :unauthorized
        end
    end


    def self.encode(user)

        issued = Time.now.to_i
        expiration_delay = Time.now.to_i + 2 * 3600 # expiration after 3600s (times) hours
    
        payload = {
            username: user[:username],
            sub: user[:id],
            iat: issued,
            exp: expiration_delay
        }
        token = JWT.encode payload, ENV['HMAC_SECRET'], 'HS256'

    end

    def self.decode(token)

        decoded_token = JWT.decode token, ENV['HMAC_SECRET'], true, { algorithm: 'HS256' }

    end



end
