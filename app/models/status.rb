class Status < ApplicationRecord
    has_many :blocks
    has_many :tasks

    # created > upon creation, before pressing "Start"
    # pending > if est_start_date is less than current_date, before pressing "Start"
    # in progress > after pressing "Start", but before pressing "Finished"
    # delayed > if est_end_date is less than current_date, before pressing "Finished"
    # completed > upon pressing "Finished"
end
