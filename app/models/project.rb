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
        task_date = self.tasks.map do |task| task.est_start_date end.min
        return task_date if task_date < self.est_start_date
        return self.est_start_date if task_date >= self.est_start_date
    end
    
    def calc_est_end
        task_date = self.tasks.map do |task| task.est_end_date end.max
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
