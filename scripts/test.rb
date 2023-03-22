require 'test/unit'
require 'fileutils'
require './ls.rb'

# A ruby unit test for list_files
# The test creates a directory with a few files and then calls list_files
# The test directory and files are removed after the test

class TestListFiles < Test::Unit::TestCase

  def setup
    # Create a test directory
    @test_dir = "test_dir"
    # If test directory already exists, skip file creation
    if !Dir.exist?(@test_dir)
    
        Dir.mkdir(@test_dir)
        # Create a few files in the test directory
        FileUtils.touch("#{@test_dir}/file1")
        FileUtils.touch("#{@test_dir}/file2")
        FileUtils.touch("#{@test_dir}/file3")
    end

    # Write the expected output to a string
    @expected_output = "Name    | Size    | Last Modified
---------------------
file3   | 0       | #{File.mtime("#{@test_dir}/file3")}
file2   | 0       | #{File.mtime("#{@test_dir}/file2")}
file1   | 0       | #{File.mtime("#{@test_dir}/file1")}
"
    end

    def teardown
        # Remove the test directory
        FileUtils.rm_rf(@test_dir)
    end

    # Assert that calling ls command from the terminal returns the expected output       
    def test_ls_command
        # Run the ls command from the terminal
        output = `ruby ls.rb #{@test_dir}`
        # Compare the output to the expected output
        assert_equal(@expected_output, output)
    end
    
    # Assert that calling ls command with no arguments returns something
    def test_ls_no_args
        # Run the ls command from the terminal
        output = `ruby ls.rb`
        # Compare the output to the expected output
        assert_not_equal("", output)
    end

    # Assert that calling ls command with an invalid directory returns directory does not exist
    def test_ls_invalid_dir
        # Run the ls command from the terminal
        output = `ruby ls.rb invalid_dir`
        # Compare the output to the expected output
        assert_equal("Directory invalid_dir does not exist  
", output)
    end

end
