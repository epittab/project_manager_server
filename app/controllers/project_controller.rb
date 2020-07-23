class ProjectController < ApplicationController
  before_action :authorize_request

  def create
    new_project = Project.create(project_name: params[:project][:project_name], 
                                project_description: params[:project][:project_description], 
                                est_start_date: params[:project][:est_start_date], 
                                est_end_date: params[:project][:est_end_date])
    if (new_project)
      UserProject.create(user_id: @current_user.id, project_id: new_project.id, role_id: '1')
      render json: new_project, status: :ok
    else

      render json: {error: true, message: "Project was not created."}, status: :unprocessable_entity
    end

  end

  def index
    render json: @current_user.projects, status: :ok
  end

  def update
  end

  def destroy
  end

  def budget
    project = Project.find(params[:id])
    total = project.calculate_budget
    budget_per_task = project.tasks.map do |task| {task: task.task_name, budget: task.budget_amount, labor_costs: task.labor_costs, serv_mat_costs: task.serv_mat_costs} end
    render json: {total_budget: total, budget_per_task: budget_per_task}, status: :ok
  end

  def show
    project = Project.find(params[:id])

    blockArray = project.blocks.map do |block|     
      tasks = block.tasks
      (tasks.length > 0) ? b_e_date = block.est_end_date : b_e_date = nil
      (tasks.length > 0) ? b_s_date = block.est_start_date : b_s_date = nil
      { :block => block, :b_e_date => b_e_date, :b_s_date => b_s_date, :tasks => tasks }
    end

    project_days = project.display_length
    project_start = project.display_start

    render json: {project: project, blocks: blockArray, days: project_days, display_start: project_start}, status: :ok
  end

  private
  def project_params(*args)
    params.require(:project).permit(*args)
  end

end

# t.string "project_name"
# t.text "project_description"
# t.date "est_start_date"
# t.date "est_end_date"

# t.integer "user_id"
#     t.integer "project_id"
#     t.integer "role_id"