class Task < ApplicationRecord
    belongs_to :block
    has_many :material_tasks
    has_many :service_tasks
    has_many :time_tasks
end
