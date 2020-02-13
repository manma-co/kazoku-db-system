class RenameRequestLogToStudyAbroad < ActiveRecord::Migration[5.0]
  def change
    rename_table :request_logs, :study_abroads
    rename_column :email_queues, :request_log_id, :study_abroad_id
    rename_column :request_days, :request_log_id, :study_abroad_id
    rename_column :reply_logs, :request_log_id, :study_abroad_id
    rename_column :event_dates, :request_log_id, :study_abroad_id
  end
end
