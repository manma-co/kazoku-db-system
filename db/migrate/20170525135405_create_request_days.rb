class CreateRequestDays < ActiveRecord::Migration[5.0]
  def change
    create_table :request_days do |t|
      t.integer :request_log_id
      t.date :day
      t.string :time
      t.boolean :decided

      t.timestamps
    end
    add_reference :request_days, :request_logs
  end
end
