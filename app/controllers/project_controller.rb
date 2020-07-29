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
    user_project_array = @current_user.projects.map do |up| {project: up, isComplete: up.is_completed?} end
    render json: user_project_array, status: :ok
  end

  def update
  end

  def destroy
  end

  def budget
    project = Project.find(params[:id])
    total = project.calculate_budget
    budget_per_task = project.tasks.map do |task| 
      modified_lc_array = task.labor_costs.map do |lc| {id: lc.id, task_id: lc.task_id, user_id: lc.user_id, labor_name: lc.time_task_name, labor_description: lc.time_task_description, user_hours: lc.user_hours, calculated_cost: lc.user_labor_cost } end
      {task: task.task_name, budget: task.budget_amount, labor_costs: modified_lc_array, serv_mat_costs: task.serv_mat_costs} end
    render json: {total_budget: total, budget_per_task: budget_per_task}, status: :ok
  end

  def show
    project = Project.find(params[:id])
    project.refresh
    blockArray = project.blocks.map do |block|     
      tasks = block.tasks
      (tasks.length > 0) ? b_e_date = block.est_end_date : b_e_date = nil
      (tasks.length > 0) ? b_s_date = block.est_start_date : b_s_date = nil
      { :block => block, :b_e_date => b_e_date, :b_s_date => b_s_date, :tasks => tasks }
    end

    isComplete = project.is_completed?

    project_days = project.display_length
    project_start = project.display_start

    render json: {project: project, isComplete: isComplete, blocks: blockArray, days: project_days, display_start: project_start}, status: :ok
  end

  def performance
    project = Project.find(params[:id])
    if project
      kpis = project.indicators
      render json: kpis, status: :ok
    else
      render json: {error: true, message: "Could not generate indicators"}, status: 400
    end
  end
  
  def allperformance
    user_project_array = @current_user.projects.map do |up|
      ind_list = up.indicators
      {id: up.id, indicators: ind_list}
    end
    if user_project_array
      render json: user_project_array, status: :ok
    else
      render json: {error: true, message: "Could not generate indicators"}, status: 400
    end
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