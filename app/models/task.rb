class Task < ApplicationRecord
    belongs_to :block
    belongs_to :status
    has_many :serv_mat_costs
    has_many :labor_costs
end
