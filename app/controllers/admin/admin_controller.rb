class Admin::AdminController < ApplicationController
  layout 'admin/admin'
  before_action :authenticate_admin!
end
