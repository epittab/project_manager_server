class BlockController < ApplicationController
  before_action :authorize_request

  def create
    new_block = Block.create(project_id: params[:project_id], block_name: params[:block_name], block_description: params[:block_description])
    if (new_block)
      render json: new_block, status: :ok
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
  end

  def show
  end
  
  private 

  def block_params(*args)
    params.require(:block).permit(*args)
  end


end

# .integer "project_id"
#     t.string "block_name"
#     t.text "block_description"