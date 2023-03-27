# spec/api/album_spec.rb
require './spec/spec_helper'

describe 'Healthcheck Endpoint' do
  it 'returns ok' do
    get '/healthcheck'
    expect(last_response).to be_ok
  end
end

describe 'Upload Endpoint' do
  include Rack::Test::Methods

  # Create two temporary jpg files before the test
  before(:each) do
    create_temp_file('test.jpg')
    create_temp_file('test_big.jpg', 1024 * 1024 * 11)
  end

  # Delete the temporary file after the test
  after(:each) do
    delete_temp_file('test.jpg')
    delete_temp_file('test_big.jpg')
  end 

  it 'returns ok' do
    # Mock the save_file_to_s3 function
    allow_any_instance_of(Object).to receive(:save_file_to_s3).and_return('https://s3.amazonaws.com/album-images/test.jpg')
    post '/upload', file: Rack::Test::UploadedFile.new('spec/fixtures/test.jpg', 'image/jpeg') 
    expect(last_response).to be_ok
  end

  it 'returns 400 if file is over 10MB' do
    # Mock the save_file_to_s3 function
    allow_any_instance_of(Object).to receive(:save_file_to_s3).and_return('https://s3.amazonaws.com/album-images/test_big.jpg')
    post '/upload', file: Rack::Test::UploadedFile.new('spec/fixtures/test_big.jpg', 'image/jpeg') 
    # Check if the response is 400
    expect(last_response.status).to eq(400)
  end
end

# A function that creates a temporary image of a given size
# The function takes the file name as a parameter
# The function returns the path of the file
# The function takes the file size as a parameter and creates a file of that size
def create_temp_file(file_name, file_size=100)
  # Add spec/fixtures to the file name
  file_name = "spec/fixtures/#{file_name}"
  # Create a new file
  file = File.new(file_name, 'w')
  # Write the file
  file.write('a' * file_size)
  # Close the file
  file.close
  # Return the file path
  file.path
end

# A function that deletes a temporary file
# The function takes the file name as a parameter
def delete_temp_file(file_name)
  # Add spec/fixtures to the file name
  file_name = "spec/fixtures/#{file_name}"
  # Delete the file
  File.delete(file_name)
end
