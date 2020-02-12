class EmailQueue < ApplicationRecord
  belongs_to :request_log

  def status
    sent_status ? '送信済み' : '未送信'
  end
end
