class Project < ApplicationRecord
    has_many :user_projects
    has_many :blocks
    has_many :tasks, through: :blocks
    has_many :users, through: :user_projects


    def refresh
        self.tasks.each do |t| t.refresh_status end
        self.blocks.each do |b| b.refresh_status end
    end

    def generalIndicators
        return {
            project_count: 1
        }
    end


    def indicators
        return {
            percent_complete: self.percent_complete,
            task_count: self.task_count,
            block_count: self.block_count,
            duration: self.display_length,
            days_remaining: self.days_remaining,
            days_worked: self.working_days,
            total_budget: self.calculate_budget,
            isOverBudget: self.isOverBudget?,
            total_cost: self.calculate_cost,
            team_members: self.team_count,
            task_dist: self.task_dist_by_status,
          }

    end


    def calculate_budget
        total_allocated = 0
        self.tasks.map do |task| 
            if task.budget_amount
                total_allocated += task.budget_amount
            end
        end
        total_allocated
    end

    def isOverBudget?
        budget = self.calculate_budget
        cost = self.calculate_cost[:total_cost]
        if cost > budget
            return [true, info: {budget: budget, cost: cost, amount: (budget - cost)}]
        elsif budget > cost
            return [false,  info: {budget: budget, cost: cost, amount: (budget - cost)}]
        else 
            return [false, info: {budget: budget, cost: cost, amount: (0.00)}]
        end
    end

    def calculate_cost
        project_cost = {
            total_cost: 0,
            labor_cost: 0,
            serv_cost: 0,
            mat_cost: 0
        }

        serv_mat_costs  = self.tasks.map do |t| t.serv_mat_costs  end.flatten
        serv_costs = serv_mat_costs.find_all do |t| t.isService end
        mat_costs = serv_mat_costs.find_all do |t| !t.isService end
        
        labor_costs = self.tasks.map do |t| t.labor_costs end.flatten
            
            if labor_costs.length > 0
                costs = labor_costs.map do |c| c.user_labor_cost end.reduce(:+)
                project_cost[:labor_cost] = costs
            end
            if serv_costs.length > 0
                costs = serv_costs.map do |c| c.serv_mat_cost end.reduce(:+)
                project_cost[:serv_cost] = costs
            end
            if mat_costs.length > 0
                costs = mat_costs.map do |c| c.serv_mat_cost end.reduce(:+)
                project_cost[:mat_cost] = costs
            end

        project_cost[:total_cost] = project_cost[:labor_cost] + project_cost[:serv_cost] + project_cost[:mat_cost]

        return project_cost

    end


    def team_count
        self.users.count
    end

    def task_dist_by_status
        task_dist = {
            :Created => 0,
            :Completed => 0,
            :Pending => 0,
            :Delayed => 0,
            :"In Progress" => 0

        }
        task_array = self.tasks.map do |task| task.status end.each do |t|
            name = t.status_name.to_sym
            task_dist[name] += 1
        end
        return task_dist
    end

    def percent_task(status_name)
        task_array = self.tasks
        completed_tasks = task_array.map do |task| task.status end.find_all do |t| t.status_name == status_name end.count
        total_tasks = task_array.count
        return completed_tasks/total_tasks.to_f
    end

    def percent_complete
        self.percent_task("Completed")
    end

    def percent_pending
        self.percent_task("Pending")
    end

    def percent_delayed
        self.percent_task("Delayed")
    end

    def percent_in_progress
        self.percent_task("In Progress")
    end

    def task_count
        self.tasks.count
    end

    def block_count
        self.blocks.count
    end


    def display_start
        current_date = Date.today
        est_date = self.calc_est_start || self.est_start_date
        act_date = self.calc_act_start 

        if !act_date
            return est_date if est_date < current_date
            return current_date unless ( est_date - current_date ).to_i > 7
            return est_date
        else
            return est_date if est_date < act_date
            return act_date if act_date <= est_date
        end

        # return Date
    end

    def days_remaining
        if !self.is_completed?
            e_end = self.calc_est_end
            a_end = self.calc_act_end || e_end
            current_date = Date.today
            latest_date = e_end >= a_end ? e_end : a_end
            return (latest_date - current_date).to_i
        else 
            return false
        end 
    end


    def display_length
        e_start = self.calc_est_start
        a_start = self.calc_act_start || e_start
        e_end = self.calc_est_end
        a_end = self.calc_act_end || e_end
        current_date = Date.today

        if !self.is_completed?
            #calculate based on incomplete project
            
            earliest_date = e_start <= a_start ? e_start : a_start 
            latest_date = e_end >= a_end ? e_end : a_end

            earliest_date = earliest_date <= current_date ? earliest_date : current_date 
            latest_date = latest_date >= current_date ? latest_date : current_date
            return (latest_date - earliest_date).to_i
            #return int
        else
            # calculate based on completed project
            earliest_date = e_start <= a_start ? e_start : a_start 
            latest_date = e_end >= a_end ? e_end : a_end
            return (latest_date - earliest_date).to_i
            #return int
        end
    end

    def working_days
        if self.is_completed?
            a_start = self.calc_act_start 
            a_end = self.calc_act_end
            return (a_end - a_start).to_i + 1
        else 
            return false
        end 

    end


    def is_completed?
        task_list = self.tasks
        if task_list.length > 0
            return self.tasks.map{ |t| t.status_id }.all?{ |status| status == 5 }
        end
        return false
    end
    
    def calc_est_start
        task_date = self.tasks.map do |task| task.est_start_date end.min || self.est_start_date
       
            return task_date if task_date < self.est_start_date
            return self.est_start_date if task_date >= self.est_start_date
    end
    
    def calc_est_end
        task_date = self.tasks.map do |task| task.est_end_date end.max || self.est_end_date
        return task_date if task_date > self.est_end_date
        return self.est_end_date if task_date <= self.est_end_date
    end
    
    def calc_act_start
        task_date = self.tasks.map { |task| task.act_start_date }.filter{ |asd| !!asd }.min
    end
    
    def calc_act_end
        task_date = self.tasks.map { |task| task.act_end_date }.filter{ |asd| !!asd }.max
    end


end
