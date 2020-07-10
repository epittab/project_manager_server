class Block < ApplicationRecord
    belongs_to :project
    has_many :tasks
end
