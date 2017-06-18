class CreateReplyLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :reply_logs do |t|
      t.boolean :result
      t.belongs_to :request_log, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
