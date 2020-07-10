class Role < ApplicationRecord
    has_many :user_projects
end
