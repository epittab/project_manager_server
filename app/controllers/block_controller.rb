class BlockController < ApplicationController
  before_action :authorize_request

  def create
    new_block = Block.create(project_id: params[:project_id], block_name: params[:block_name], block_description: params[:block_description], status_id: 6)
    if (new_block)
      render json: {block: new_block, tasks: []}, status: :ok
    else
      render json: {error: true, message: 'Block not created.'}, status: :unprocessable_entity
    end
  end

  def index
    # needs to know which project
    render json: @current_user.projects, status: :ok
  end

  def update
  end

  def destroy
    block = Block.destroy(params[:id])
    if block
      render json: block, status: :ok
    else
      render json: {error: true, message: 'Resource delete was unsuccessful'}, status: :bad_request
    end
  end

  def show
    block = Block.find(params[:id])

    tasks_array = block.tasks
    # blockArray = project.blocks.map do |block|     
    #   tasks = block.tasks
    #   (tasks.length > 0) ? b_e_date = block.est_end_date : b_e_date = nil
    #   (tasks.length > 0) ? b_s_date = block.est_start_date : b_s_date = nil
    #   { :block => block, :b_e_date => b_e_date, :b_s_date => b_s_date, :tasks => tasks }
    # end

    render json: {block: block, tasks: tasks_array}, status: :ok
  end
  
  private 

  def block_params(*args)
    params.require(:block).permit(*args)
  end


end

# .integer "project_id"
#     t.string "block_name"
#     t.text "block_description"