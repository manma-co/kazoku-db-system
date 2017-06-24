class StaticPagesController < ApplicationController
  def index
    RequestLog.three_days_reminder
  end
end
