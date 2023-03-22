# A function to generate a template github README file for a application project
def readme
  # Get the project name from the current directory
  project_name = File.basename(Dir.getwd)
  # Get the current year
  year = Time.now.year
  # Get the current user name
  user_name = `git config --get user.name`.chomp
  # Get the current user email
  user_email = `git config --get user.email`.chomp

  # Generate the README file
  File.open('README.md', 'w') do |f|
    f.puts "# #{project_name}"
    f.puts
    f.puts '## Description'
    f.puts
    f.puts '## Installation'
    f.puts
    f.puts '## Usage'
    f.puts
    f.puts '## Contributing'
    f.puts
    f.puts '## License'
    f.puts
    f.puts "This project is licensed under the terms of the MIT license."
    f.puts
    f.puts "© #{year} #{user_name} <#{user_email}>"
  end
end

readme()