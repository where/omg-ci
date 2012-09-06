class AlterSuiteAddNotifyEmail < ActiveRecord::Migration
  def up
    add_column :suites, :email_notification, :string
  end

  def down
    remove_column :suites, :email_notification
  end
end
