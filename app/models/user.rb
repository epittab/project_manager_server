class User < ApplicationRecord
    has_secure_password

    has_many :user_projects
    has_many :projects, through: :user_projects

    def indicators
        return {
            completed: self.completed_projects,
            current: self.current_projects,
            budget: self.managed_budget,
            delayed: self.delayed_tasks,
            in_progress: self.current_tasks,
            contributors: self.contributor_count,
          }
    end

    def completed_projects
        self.projects.map do |p| p.is_completed? end.count(true)
    end

    # works
    def current_projects 
        # return number
        self.projects.map do |p| p.is_completed? end.count(false)
    end

    # works
    def managed_budget 
        # returns number
        self.projects.map do |p| p.calculate_budget end.reduce(:+)
    end

    def delayed_tasks
        # return array
        self.projects.map do |p| p.tasks end.flatten.filter do |t| t.status.status_name == "Delayed" end
    end
 
    def current_tasks
        # return array
        self.projects.map do |p| p.tasks end.flatten.filter do |t| t.status.status_name == "In Progress" end
    end

    def contributor_count
        #returns number
        requester = self.id
        projects_array = UserProject.where("user_id = ?", requester)
        contrib_count = projects_array.map do |p| p.project.users end.flatten.filter do |u| u.id != requester end.count
    end
end
