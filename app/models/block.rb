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

end
