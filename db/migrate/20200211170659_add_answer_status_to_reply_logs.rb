class AddAnswerStatusToReplyLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :reply_logs, :answer_status, :integer, default: 0
    add_index :reply_logs, :answer_status
  end
end
