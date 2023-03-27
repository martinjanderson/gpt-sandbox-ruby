require 'sinatra'
require 'aws-sdk-s3'
require 'aws-sdk-cognitoidentityprovider'
require 'dotenv'

Dotenv.load

# Configure AWS
Aws.config.update({
    region: 'us-east-1',
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
})

def authenticate_user(access_token)
    client = Aws::CognitoIdentityProvider::Client.new(
        region: 'us-east-1'
    )

  begin
    response = client.get_user(access_token: access_token)
    email = response.user_attributes.find { |attr| attr.name == 'email' }.value
  rescue Aws::CognitoIdentityProvider::Errors::NotAuthorizedException
    halt 401, 'Unauthorized'
  end

  email
end

before do
    
    pass if request.path_info == '/healthcheck'

    access_token = request.env['HTTP_AUTHORIZATION']&.gsub('Bearer ', '')
    halt 401, 'Unauthorized' if access_token.nil?
  
    @current_user_email = authenticate_user(access_token)
end

# A healthcheck endpoint for the application
get '/healthcheck' do
    'OK'
end

# An endpoint to upload a valid image file
# The image file is saved to an amazon s3 bucket
# The endpoint throws an exception if the file is over 10MB
post '/upload' do
    # Get the file from the request
    file = params[:file]
    # Check if the image file is over 10MB throw an error
    if file[:tempfile].size > convert_to_bytes('10MB')
        halt 400, 'File is over 10MB'
    end
  
    # Call save_file_to_s3 function to save the file to an amazon s3 bucket
    url = save_file_to_s3(file[:filename], file[:tempfile])
    
end


# A function that saves a file to an amazon s3 bucket
# The function takes the file name and the file data as parameters
# The function returns the url of the file in the amazon s3 bucket
def save_file_to_s3(file_name, file_data)
    # Create a new amazon s3 bucket object
    s3 = Aws::S3::Resource.new(region: 'us-east-1')
    # Create a new bucket object if it does not exist 
    bucket = s3.bucket('album-images')
    # Create a new object in the bucket
    obj = bucket.object(file_name)
    # Upload the file to the bucket
    obj.upload_file(file_data)
    # Return the url of the file in the bucket
    obj.public_url
end

# A function that covert a file size to bytes
def convert_to_bytes(file_size)
    units = {
      'B' => 1,
      'KB' => 1024,
      'MB' => 1024**2,
      'GB' => 1024**3,
      'TB' => 1024**4,
      'PB' => 1024**5
    }
  
    size, unit = file_size.upcase.match(/(\d+(?:\.\d+)?)([A-Z]+)/).captures
    size.to_f * (units[unit] || 1)
  end
