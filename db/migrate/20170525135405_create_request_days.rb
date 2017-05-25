class CreateRequestDays < ActiveRecord::Migration[5.0]
  def change
    create_table :request_days do |t|
      t.belongs_to :request_log
      t.date :day
      t.string :time
      t.boolean :decided

      t.timestamps
    end
  end
end
