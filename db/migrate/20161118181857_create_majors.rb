class CreateMajors < ActiveRecord::Migration
  def change
    create_table :majors do |t|

      t.timestamps null: false
    end
  end
end
