
# Function that takes terminal arguments and treats the first arguement as a directory
# If no arguments are given, the current directory is used
# If the directory does not exist, an error message is printed
# If the directory exists, the list_files function is called
def ls_main
    if ARGV.length == 0
        dir = "."
    else
        dir = ARGV[0]
    end
    if Dir.exist?(dir)
        list_files(dir)
    else
        puts "Directory #{dir} does not exist"
    end
end

# Function to list all files in a directory in tabular format.
# Lists each file with its name, size, and last modified date.
# File size is a result of get_file_size function
# Can take relative or absolute paths.
# The table is sorted by last modified date.
# The columns adjust their width to the size of the longest entry. 
# The table columns are outlined in ascii characters
def list_files(dir)
    # Get the files in the directory
    files = Dir.entries(dir)
    # Remove the . and .. entries
    files.delete(".")
    files.delete("..")
    # Get the longest file name
    longest_name = files.max_by(&:length).length
    # Get the longest file size
    longest_size = files.max_by { |f| get_file_size("#{dir}/#{f}") }.length
    # Get the longest last modified date
    longest_date = files.max_by { |f| File.mtime("#{dir}/#{f}") }.length
    # Print the table header
    puts "Name".ljust(longest_name + 2) + " | " + "Size".ljust(longest_size + 2) + " | " + "Last Modified".ljust(longest_date + 2)
    puts "-" * (longest_name + longest_size + longest_date + 6)
    # Print each file in the directory
    files.each do |f|
        # Get the file size
        size = get_file_size("#{dir}/#{f}")
        # Get the last modified date
        date = File.mtime("#{dir}/#{f}")
        # Print the file name, size, and last modified date
        puts f.ljust(longest_name + 2) + " | " + size.to_s.ljust(longest_size + 2) + " | " + date.to_s.ljust(longest_date + 2)
    end
end


# Function to get the size of a file 
def get_file_size(file)
    if File.directory?(file)
        size = 0
        return size
    else
        return File.size(file)
    end
end

ls_main

