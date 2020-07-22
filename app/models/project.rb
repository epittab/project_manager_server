class Project < ApplicationRecord
    has_many :user_projects
    has_many :blocks
    has_many :tasks, through: :blocks
    has_many :users, through: :user_projects

    def calculate_budget
        total_allocated = 0
        self.tasks.map do |task| 
            if task.budget_amount
                total_allocated += task.budget_amount
            end
        end
        total_allocated
    end

    def calc_est_start
        task_date = self.tasks.map do |task| task.est_start_date end.min
    end
    
    def calc_est_end
        task_date = self.tasks.map do |task| task.est_end_date end.max
    end
    
    def calc_act_start
        task_date = self.tasks.map do |task| task.act_start_date end.min
    end
    
    def calc_act_end
        task_date = self.tasks.map do |task| task.act_end_date end.max
    end


end
