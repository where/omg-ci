class AlterProjectAddOmgPullRequest < ActiveRecord::Migration
  def up
    add_column :projects, :omg_pull_request, :boolean
  end

  def down
    remove_column :projects, :omg_pull_request
  end
end
