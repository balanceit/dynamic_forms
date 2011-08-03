class Project < ActiveRecord::Base
  attr_protected :id
end

class Goal < ActiveRecord::Base
  attr_protected :id
  belongs_to  :project
end