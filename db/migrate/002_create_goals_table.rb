class CreateGoalsTable < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.integer     :id
      t.integer     :project_id
      t.string      :name
    end
  end

  def self.down
    drop table :goals
  end
end