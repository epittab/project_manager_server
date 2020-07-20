class TaskController < ApplicationController

  before_action :authorize_request

  def create
    # block = Block.find_by()
    new_task = Task.create(block_id: params[:b_id], task_name: params[:task_name], task_description: params[:task_description], est_start_date: params[:task_start_date], est_end_date: params[:task_end_date], act_start_date: nil, act_end_date: nil)
    if new_task
      render json: new_task, status: :ok
    else
      render json: {error: true, message: 'Task was not created.'}, status: :unprocessable_entity
    end
  end

  def index
  end

  def update
  end

  def destroy
  end

  def show
    task = Task.find(params[:id])
    if task
      render json: task, status: :ok
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