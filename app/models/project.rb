class Project < ApplicationRecord
    has_many :user_projects
    has_many :blocks
    has_many :tasks, through: :blocks
    has_many :users, through: :user_projects

    def calculate_budget
        total_allocated = 0
        self.tasks.map do |task| task.budget_amount end.reduce(:+)
    end

    def est_start_date
        task_date = self.tasks.map do |task| task.est_start_date end.min
    end
    
    def est_end_date
        task_date = self.tasks.map do |task| task.est_end_date end.max
    end
    
    def act_start_date
        task_date = self.tasks.map do |task| task.act_start_date end.min
    end
    
    def act_end_date
        task_date = self.tasks.map do |task| task.act_end_date end.max
    end


end
