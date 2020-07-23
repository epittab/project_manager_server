class TaskController < ApplicationController

  before_action :authorize_request

  def create
    # block = Block.find_by()
    new_task = Task.create(block_id: params[:b_id], task_name: params[:task_name], task_description: params[:task_description], est_start_date: params[:task_start_date], est_end_date: params[:task_end_date], act_start_date: nil, act_end_date: nil, status_id: 6)
    if new_task
      render json: new_task, status: :ok
    else
      render json: {error: true, message: 'Task was not created.'}, status: :unprocessable_entity
    end
  end

  def index
  end

  def update
    edit_task = Task.find(params[:id])
    if edit_task
      
      if params[:payload] == 3 && params[:field] == 'status_id'
        edit_task.start_task
        edit_task.update(params[:field] => params[:payload].to_i)
      elsif params[:payload] == 5 && params[:field] == 'status_id'
        edit_task.end_task
        edit_task.update(params[:field] => params[:payload].to_i)
      end
      render json: edit_task, status: :ok
    else
      render json: {error: true, message: "Task update unsuccessful"}, status: :bad_request
    end

  end

  def budget
    task = Task.find(params[:id])
    task.budget_amount = params[:budget_amount].to_f
    if task.save
      render json: task, status: :ok
    else
      render json: {error: true, message: "Budgeting unsuccessful"}, status: :unprocessable_entity
    end

  end


  def destroy
  end

  def show
    task = Task.find(params[:id])
    if task
      status_name = task.status.status_name
      costs = {labor_costs: task.labor_costs, serv_mat_costs: task.serv_mat_costs}
      render json: {task: task, costs: costs, task_status: status_name}, status: :ok
    else
      render json: {error: true, message: "Task not found."}, status: 404
    end

  end
  
  private
  
  def task_params(*args)
    params.require(:task).permit(*args)
  end
end

# t.integer "block_id"
# t.string "task_name"
# t.text "task_description"
# t.date "est_start_date"
# t.date "est_end_date"
# t.date "act_start_date"
# t.date "act_end_date"