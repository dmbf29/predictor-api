# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins [
      %r(\Ahttps?:\/\/localhost:\d{4})
      # TODO: Add production domain and Netlify urls for staging/previews:
      # %r(\Ahttps?:\/\/.+\.app-name\.com),
      # %r(\Ahttps?:\/\/.*app-name\.netlify\.app),
    ]

    resource '*',
      headers: :any,
      expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
      methods: [:get, :post, :options, :delete, :put],
      credentials: true
  end
end
