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

end
