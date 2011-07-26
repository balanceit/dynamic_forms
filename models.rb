class Project < ActiveRecord::Base
end

class Goal < ActiveRecord::Base
  belongs_to  :project
end