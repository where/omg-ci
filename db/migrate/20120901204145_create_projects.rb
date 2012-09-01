class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :git_repo
      t.string :status
      t.timestamps
    end
  end
end
