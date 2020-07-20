class Status < ApplicationRecord
    has_many :blocks
    has_many :tasks
end
