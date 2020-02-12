
# I finally detect the reason about those error below which says Authentication failure! csrf_detected: OmniAuth::Strategies::OAuth2::CallbackError, csrf_detected.

# Started GET "/admins/auth/google_oauth2/callback?state=da3a8979343a061a8738b188efa04e5252e02a9e30f0de18&code=4/ValDct8VnDvQdYYTVU9bLE7ZSrWC8CBCmWbKfcvauh0" for ::1 at 2017-04-09 12:14:27 +0900
# I, [2017-04-09T12:14:27.286700 #36087]  INFO -- omniauth: (google_oauth2) Callback phase initiated.
# I, [2017-04-09T12:14:27.775601 #36087]  INFO -- omniauth: (google_oauth2) Callback phase initiated.
# E, [2017-04-09T12:14:27.775776 #36087] ERROR -- omniauth: (google_oauth2) Authentication failure! csrf_detected: OmniAuth::Strategies::OAuth2::CallbackError, csrf_detected | CSRF detected
# Processing by Admin::OmniauthCallbacksController#failure as HTML

# This configuration file cause error, so I remove those.

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google_oauth2, Rails.application.secrets.google_client_id, Rails.application.secrets.google_client_secret
# end
