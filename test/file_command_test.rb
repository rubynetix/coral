require 'test/unit'
require 'securerandom'
require_relative '../lib/commands/ls_command'
require_relative '../lib/commands/cd_command'
require_relative '../lib/commands/cat_command'
require_relative '../lib/commands/cp_command'
require_relative '../lib/commands/touch_command'
require_relative '../lib/commands/rm_command'
require_relative '../lib/color_text'
require_relative '../lib/commands/clear_command'

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

  def valid_dir(path)
    path.nil? ? true : Dir.exists?(File.expand_path(path))
  end

  def valid_file(path)
    path.nil? ? true : File.exists?(File.expand_path(path))
  end

  ###### TESTING ######

  def test_ls
    files = Dir.entries(@sandbox_dir).sort!
    no_hidden_files = files.select { |f| !f.start_with?('.') }
    sub_files = Dir.entries("#{@sandbox_dir}/subdir").select { |f| !f.start_with?('.') }.sort!

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
          assert_equal(e_files, printed_files.sort, "ls: Incorrect files printed for \"#{cmd}\"")

          unless tokens.include?('-a') or tokens.include?('--all')
            assert_false(printed_files.any? { |f| f.start_with?('.') }, "Ls does not print hidden files by default")
          end
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

      # Preconditions
      begin
        assert_equal('cd', tokens[0])
      end

      $stderr.reopen
      CdCommand.new(tokens).execute

      # Postconditions
      begin
        assert_equal(e_dir, Dir.pwd, "cd: Navigated to unexpected directory")

        unless valid_dir(tokens[1])
          assert_false($stderr.string.empty?, "cd: Invalid directory should print message to stderr")
        end
      end
    end
  end

  def test_cat
    cmd_contents = [
        ['cat', nil],  # Missing argument
        ['cat .hidden_file', "This is a hidden file.\n"],
        ['cat RandomText.txt', "I rEaLLY dont KOW how tO Spell Or FoRMat thinGs\nSpecial chars: /*-+\n"],
        ['cat .', nil], # Not a file
    ]

    cmd_contents.each do |cmd, contents|
      tokens = cmd.strip.split(' ')

      # Preconditions
      begin
        assert_equal('cat', tokens[0])
      end

      $stdout.reopen
      CatCommand.new(tokens).execute

      # Postconditions
      begin
        unless contents.nil?
          assert_equal(contents, $stdout.string, "cat: Incorrect file contents")
        end

        unless valid_file(tokens[1])
          assert_false($stderr.string.empty?, "cat: Invalid file path should print to stderr")
        end
      end
    end
  end

  def test_cp
    cp_exps = [
        ['cp', nil],
        ['cp .hidden_file', nil ],
        ['cp invalid_file subdir/new_file', nil],
        ['cp .hidden_file .hidden_file_copy', "#{@test_dir}/.hidden_file_copy" ],
        ['cp RandomText.txt subdir/RandomTextSubdir.txt', "#{@test_dir}/subdir/RandomTextSubdir.txt" ],
        ['cp subdir/hello.txt .', "#{@test_dir}/hello.txt"],
        ['cp -r subdir new_subdir', "new_subdir/hello.txt"]
    ]

    cp_exps.each do |cmd, expected_file|
      tokens = cmd.strip.split(' ')

      # Preconditions
      begin
        assert_equal('cp', tokens[0])
      end

      $stdout.reopen
      CpCommand.new(tokens).execute

      # Postconditions
      begin
        unless expected_file.nil?
          original_file = File.expand_path("#{@test_dir}/#{tokens[1]}")

          assert_true(valid_file(expected_file), "cp: File not created properly")
          assert_true(FileUtils.identical?(original_file, expected_file), "cp: Contents of the copied file is different from the original file")
        end

        unless valid_file(tokens[1])
          assert_false($stderr.string.empty?, "cat: Invalid file path should print to stderr")
        end
      end
    end
  end

  def test_clear
    clear_exps = [
        'clear',
        'clear -h',
        'clear random arguments'
    ]

    clear_exps.each do |cmd|
      tokens = cmd.strip.split(' ')

      # Preconditions
      begin
        assert_equal('clear', tokens[0])
      end

      $stdout.reopen
      ClearCommand.new(tokens).execute

      assert_equal("\e[H\e[2J\n", $stdout.string)
    end

  def test_touch
    random_file = "#{SecureRandom.hex(6)}.txt"
    tokens = ['touch', random_file]

    # Preconditions
    begin
      assert_equal('touch', tokens[0])
    end

    $stdout.reopen
    TouchCommand.new(tokens).execute

    # Postconditions
    begin
      assert_true(File.exists?(random_file))
    end

    RmCommand.new(['rm', random_file]).execute

  end
end
