# controller macros:
module ControllerMacros
  def login_admin(admin = nil)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
    admin ||= FactoryBot.create(:admin)
    sign_in admin
  end
end
