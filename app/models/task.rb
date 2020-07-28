class Task < ApplicationRecord
    belongs_to :block
    belongs_to :status
    has_many :serv_mat_costs
    has_many :labor_costs

    def start_task
        self.act_start_date = Date.today
        self.save
    end

    def end_task
        self.act_end_date = Date.today
        self.save
    end

    def is_delayed?
        task_status = self.status
        if task_status.status_name == 'Delayed'
            return true
        elsif task_status.status_name == 'In Progress' || task_status.status_name == 'Created' || task_status.status_name == 'Pending'
            curr_date = Date.today
            if curr_date > self.est_end_date
                return true
            else
                return false
            end
        else 
            return false
        end
    end

    def is_pending?
        task_status = self.status
        if task_status.status_name == 'Pending'
            return true
        elsif task_status.status_name == 'Created'
            curr_date = Date.today
            if curr_date > self.est_start_date
                return true
            else
                return false
            end
        else 
            return false
        end
    end

    def set_delayed
        task_status = self.status
        if (task_status.status_name == 'In Progress' || task_status.status_name == 'Pending' || task_status.status_name == 'Created') && self.is_delayed?
            self.update(status_id: 4)
            return self 
        else 
            return nil
        end
    end
   
    def set_pending
        task_status = self.status
        if task_status.status_name == 'Created' && self.is_pending?
            self.update(status_id: 2)
            return self 
        else
            return nil
        end
    end

    def refresh_status
        if self.is_delayed?
            updated_status = self.set_delayed
            return updated_status
        elsif self.is_pending?
            updated_status = self.set_pending
            return updated_status
        else
            return self
        end
    end

      
end
