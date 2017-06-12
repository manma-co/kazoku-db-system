class CreateRequestLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :request_logs do |t|
      t.string :hashed_key
      t.string :name
      t.string :belongs
      t.string :station
      t.text :motivation

      t.timestamps
    end
  end
end
