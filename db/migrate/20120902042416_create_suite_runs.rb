class CreateSuiteRuns < ActiveRecord::Migration
  def change
    create_table :suite_runs do |t|
      t.integer :suite_id
      t.text :result
      t.string :status
      t.string :sha
      t.timestamps
    end

    add_index :suite_runs, :suite_id
  end
end
