class EventDate < ApplicationRecord
  belongs_to :request_log
  belongs_to :user

  include ActiveModel::Model
  attr_accessor :event_time


  def nil_replace
    if self.information == ""
      "特にありません"
    else
      self.information
    end

  end

end
