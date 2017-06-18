class EmailQueue < ApplicationRecord

  belongs_to :request_log

  def status
    self.sent_status ? '送信済み' : '未送信'
  end

end
