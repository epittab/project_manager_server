class Project < ApplicationRecord
    has_many :user_projects
    has_many :blocks
end
