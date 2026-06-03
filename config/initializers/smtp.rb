# frozen_string_literal: true

# ActionMailer::Base.smtp_settings = {
#   user_name: ENV['POSTMARK_API'],
#   password: ENV['POSTMARK_API'],
#   domain: 'octacle.app',
#   address: 'smtp.postmarkapp.com',
#   port: 587,
#   authentication: :plain,
#   enable_starttls_auto: true
# }
ActionMailer::Base.postmark_settings = { api_token: ENV['POSTMARK_API'] }
