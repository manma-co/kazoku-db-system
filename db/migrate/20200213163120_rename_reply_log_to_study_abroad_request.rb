class RenameReplyLogToStudyAbroadRequest < ActiveRecord::Migration[5.0]
  def change
    rename_table :reply_logs, :study_abroad_requests
  end
end
