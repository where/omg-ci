class AlterSuiteAddTrigger < ActiveRecord::Migration
  def up
    remove_column :suites, :suite_type
    add_column :suites, :trigger, :string
    add_column :suites, :trigger_length, :integer
    add_column :suites, :trigger_metric, :string
  end

  def down
    add_column :suites, :suite_type
    remove_column :suites, :trigger
    remove_column :suites, :trigger_length
    remove_column :suites, :trigger_metric
  end
end
