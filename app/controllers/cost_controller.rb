class CostController < ApplicationController

    before_action :authorize_request

    def create
        if params[:cost_type] == 'Labor'
            cost = LaborCost.new(task_id: params[:t_id], user_id: @current_user.id, time_task_name: params[:cost_name], time_task_description: params[:cost_description], user_hours: params[:cost_amount])
        else
            cost = ServMatCost.new(task_id: params[:t_id], serv_mat_cost: params[:cost_amount], serv_mat_name: params[:cost_name], serv_mat_description: params[:cost_description], isService: (params[:cost_type] == 'Service'))
        end
        
        if cost.save
            render json: cost, status: :ok
        else
            render json: {error: true, message: 'Cost was not submitted successfully'}, status: :bad_request
        end
    end


end
