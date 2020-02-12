class DropReminders < ActiveRecord::Migration[5.0]
  def change
    drop_table :reminders do |t|
      t.belongs_to :request_log, foreign_key: true
      t.timestamps
    end
  end
end
