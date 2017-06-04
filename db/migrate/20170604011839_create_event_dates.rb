class CreateEventDates < ActiveRecord::Migration[5.0]
  def change
    create_table :event_dates do |t|
      t.date :hold_date
      t.time :start_time
      t.time :end_time
      t.belongs_to :user, foreign_key: true
      t.belongs_to :request_log, foreign_key: true
      t.string :meeting_place
      t.string :emergency_contact
      t.boolean :is_first_time, default: false
      t.text :information

      t.timestamps
    end
  end
end
