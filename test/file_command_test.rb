require 'test/unit'
require 'securerandom'
require_relative '../lib/commands/ls_command'
require_relative '../lib/commands/cd_command'
require_relative '../lib/color_text'

class FileCommandTest < Test::Unit::TestCase
  # This must be a class variable for delete hook to work properly

  TEST_ITER = 10

  def initialize(*args)
    super(*args)

    @sandbox_dir = File.expand_path('file_sandbox', __dir__)

    test_dir = File.expand_path("../test_dir_#{SecureRandom.hex(6)}", __FILE__)
    @test_dir = test_dir

    create_sandbox
    ObjectSpace.define_finalizer(self, proc { |id| self.class.delete(test_dir) })
  end

  def setup
    # Setup reading from stdout and stderr
    $stdout = StringIO.new
    $stderr = StringIO.new

    Dir.chdir(@test_dir)
  end

  def create_sandbox
    `cp -rf #{@sandbox_dir} #{@test_dir}`
  end

  def self.delete(test_dir)
    puts "Deleting #{test_dir}"
    # Delete the test directory after the tests are over
    `rm -rf #{test_dir}`
  end

  ###### TESTING ######

  def test_ls
    files = Dir.entries(@sandbox_dir).sort!
    no_hidden_files = files.select { |f| f.start_with?('.') }
    sub_files = Dir.entries("#{@sandbox_dir}/subdir").select { |f| f.start_with?('.') }.sort!

    cmds = [
      'ls',
      'ls . -a',
      "ls #{@test_dir} -a",
      "ls #{@test_dir}/subdir",
      'ls invalid_dir'
    ]

    exp_files = [
      no_hidden_files,
      files,
      files,
      sub_files,
      []
    ]

    cmds.zip(exp_files) do |cmd, e_files|
      # Preconditions
      begin
        assert_true(cmd.start_with?('ls'))
      end

      $stdout.reopen
      $stderr.reopen

      tokens = cmd.strip.split(' ')
      LsCommand.new(tokens).execute

      # Postconditions
      begin
        if !e_files.empty?
          printed_files = $stdout.string.split("\n")
                                 .reject { |f| f == '' }
                                 .map { |f| ColorText.rm_color(f) }

          assert_false(printed_files.empty?, "ls: No files printed for non-empty directory")
          assert_equal(e_files, printed_files.sort, "ls: Incorrect files printed")
        else
          # We have printed something to stderr
          assert_false($stderr.string.empty?, "ls: Invalid directory should print message to stderr")
        end
      end
    end
  end

  def test_cd
    cmd_exps = [
        ['cd', File.expand_path('~')],    # Defaults to home directory
        ['cd ~', File.expand_path('~')],
        ['cd .', @test_dir],              # No change in directory
        ['cd ..', File.expand_path('..')], # Up a directory
        ["cd #{@test_dir}/subdir", "#{@test_dir}/subdir"],
        ['cd invalid_dir', @test_dir]
    ]

    cmd_exps.each do |cmd, e_dir|
      Dir.chdir(@test_dir)
      tokens = cmd.strip.split(' ')
      valid_dir = tokens[1].nil? ? true : Dir.exists?(File.expand_path(tokens[1]))

      # Preconditions
      begin
        assert_equal('cd', tokens[0])
      end

      $stderr.reopen
      CdCommand.new(tokens).execute

      # Postconditions
      begin
        assert_equal(e_dir, Dir.pwd, "cd: navigated to unexpected directory")

        unless valid_dir
          assert_false($stderr.string.empty?, "cd: Invalid directory should print message to stderr")
        end
      end
    end
  end
end
