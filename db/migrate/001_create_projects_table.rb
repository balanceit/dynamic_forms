class CreateProjectsTable < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer   :id
      t.string    :name
    end
  end

  def self.down
    drop table :projects
  end
end