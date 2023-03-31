# config.ru
require './app/album'
require 'sinatra'
require 'puma'
require 'dotenv'

# Configure Puma as the server
configure do
  set :server, :puma
end

puts "RACK_ENV: #{ENV['RACK_ENV']}"
# Run the AlbumApp class
run AlbumApp