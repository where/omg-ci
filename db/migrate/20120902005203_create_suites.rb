class CreateSuites < ActiveRecord::Migration
  def change
    create_table :suites do |t|
      t.string :name
      t.string :suite_type
      t.integer :project_id
      t.timestamps
    end

    add_index :suites, :project_id
  end
end
