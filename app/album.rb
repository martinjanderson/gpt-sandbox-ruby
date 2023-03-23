require 'aws-sdk'
require 'sinatra'

# Configure an S3 bucket named album-images
Aws.config.update({
    region: 'us-east-1',
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
})

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
    # Check if the file is over 10MB
    if file.size > 10_000_000
        # Throw an exception if the file is over 10MB
        halt 400, "File size is over 10MB"
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
