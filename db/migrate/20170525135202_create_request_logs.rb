class CreateRequestLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :request_logs do |t|
      t.string :hashed_key
      t.string :name
      t.string :belongs
      t.string :station
      t.text :motivation
      t.integer :status, default: false # Status shows if this event is approved or not. Maybe there is more status like IN PROGRESS, SECOND CHANGE...

      t.timestamps
    end
  end
end
