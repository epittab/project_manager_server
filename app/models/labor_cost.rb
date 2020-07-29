class LaborCost < ApplicationRecord
    belongs_to :task
    belongs_to :user

    def user_labor_cost
        user = User.find(self.user_id).user_cost * self.user_hours
    end
end
