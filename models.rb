class Project < ActiveRecord::Base
  attr_protected :id
  
  # Find Projects with a description matching the search string (if supplied)
  # allways ordered by description
  def Project.find_by_name_paginated(name, limit, offset)
    name ||= ''
    limit ||= 20
    # max limit is 200
    limit = 200 if limit > 200
    offset ||= 0
    self.find(:all,
              :conditions => ["name like ?", name + '%'],
              :order => 'id',
              :limit => limit,
              :offset => offset)
  end
end

class Goal < ActiveRecord::Base
  attr_protected :id
  belongs_to  :project
end