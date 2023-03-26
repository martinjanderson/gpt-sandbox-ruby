# config.ru
require './app/album'
require 'sinatra'
require 'puma'

# Set the Sinatra app as the Rack application
run Sinatra::Application

# Configure Puma as the server
configure do
  set :server, :puma
end
