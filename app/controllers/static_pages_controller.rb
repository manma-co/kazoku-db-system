class StaticPagesController < ApplicationController
  def index
    RequestLog.ten_days_over
    RequestLog.three_days_reminder
  end
end
