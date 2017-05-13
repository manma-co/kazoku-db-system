class EmailQueue < ApplicationRecord

  def status
    self.sent_status ? '送信済み' : '未送信'
  end

end
