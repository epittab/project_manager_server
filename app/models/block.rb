class Block < ApplicationRecord
    belongs_to :project
    has_many :tasks, dependent: :destroy
    belongs_to :status

    def est_start_date
        task_date = self.tasks.map do |task| task.est_start_date end.min
    end
    
    def est_end_date
        task_date = self.tasks.map do |task| task.est_end_date end.max
    end

    def is_completed?
        return self.tasks.map do |t| t.status.status_name end.all? { |s| s == 'Completed' }
    end

    def is_delayed?
        if self.status.status_name != 'Completed'
            current_date = Date.today
            return current_date > self.est_end_date
        else 
            return false
        end
    end

    def is_pending?

        array_of_statuses = self.tasks.map do |t| t.status.status_name end
        none_delayed = array_of_statuses.none? { |s| s == 'Delayed' }
        none_completed = array_of_statuses.none? { |s| s == 'Completed' }
        none_in_progress = array_of_statuses.none? { |s| s == 'In Progress' }

        current_date = Date.today

        if none_completed && none_delayed && none_in_progress && (current_date > self.est_start_date) 
            return true
        else
            return false
        end
    end


    def refresh_status
        curr_block_status = self.status.status_name
        array_of_statuses = self.tasks.map do |t| t.status.status_name end
        
        if array_of_statuses.count == 0 && self.status.status_name != "Created"
            block = self.update(status_id: 6)
            return block
        elsif array_of_statuses.count == 0
            return nil
        elsif array_of_statuses.all? { |s| s == 'Completed' }
            if curr_block_status == 'Completed'
                return nil
            else
                block = self.update(status_id: 5)
                return block
            end
        elsif self.is_delayed?
            if curr_block_status == 'Delayed'
                return nil
            else
                block = self.update(status_id: 4)
                return block
            end
        elsif self.is_pending?
            if curr_block_status == 'Pending'
                return nil
            else
                block = self.update(status_id: 2)
                return block
            end
        elsif array_of_statuses.any? { |s| s == 'In Progress' }
            if curr_block_status == 'In Progress'
                return nil
            else
                block = self.update(status_id: 3)
                return block
            end
        else
            return nil
        end
        
    end

end
