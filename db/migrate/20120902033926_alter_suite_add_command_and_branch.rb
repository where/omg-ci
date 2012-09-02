class AlterSuiteAddCommandAndBranch < ActiveRecord::Migration
  def up
    add_column :suites, :command, :text
    add_column :suites, :branch, :string
  end

  def down
    remove_column :suites, :command
    remove_column :suites, :branch
  end
end
