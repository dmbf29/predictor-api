# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins [
      # Local server
      %r{\Ahttps?://localhost:\d{4}},
      # Netlify app and preview deploys
      %r{\Ahttps?://(.+--)?soccer-predictor\.netlify\.app}
      # TODO: Add production domain url:
      # %r(\Ahttps?:\/\/.+\.app-name\.com),
    ]

    resource '*',
             headers: :any,
             expose: %w[access-token expiry token-type uid client],
             methods: %i[get post options delete put],
             credentials: true
  end
end
