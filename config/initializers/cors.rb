# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', 
      headers: :any, 
      methods: [:get, :post, :patch, :put, :delete, :options, :head]
    end

    allow do
      origins 'localhost:3001'
      resource '*', 
      headers: :any, 
      methods: :any
    end
end