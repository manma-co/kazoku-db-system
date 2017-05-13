class CreateEmailQueues < ActiveRecord::Migration[5.0]
  def change
    create_table :email_queues do |t|
      t.string :sender_address, null: false
      t.string :to_address, null: false
      t.string :cc_address
      t.string :bcc_address
      t.string :subject
      t.text :body_text
      t.integer :retry_count
      t.boolean :sent_status
      t.string :email_type
      t.datetime :time_delivered

      t.timestamps
    end
  end
end
