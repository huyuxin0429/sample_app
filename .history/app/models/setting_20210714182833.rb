# RailsSettings Model
class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  # Define your fields
  # field :host, type: :string, default: "http://localhost:3000"
  # field :default_locale, default: "en", type: :string
  # field :confirmable_enable, default: "0", type: :boolean
  # field :admin_emails, default: "admin@rubyonrails.org", type: :array
  # field :omniauth_google_client_id, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_ID"] || ""), type: :string, readonly: true
  # field :omniauth_google_client_secret, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_SECRET"] || ""), type: :string, readonly: true
  
  field :drone_num, type: :integer, default: 3
  field :time_delta_in_seconds, type: :integer, default: 5
  field :drone_speed, type: :integer, default: 1
  field :drone_sim_initialised, type: :boolean, default: false
  field :test_websocket_message, type: :string, default: "default test message"
  field :test_websocket_message_channel, type: :string, default: "drone_channel_user_2"
  field :shortest_paths, type: :array, default: []
  field :next, type: :array, default: []
end
