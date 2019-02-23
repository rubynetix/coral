require 'test/unit'
require 'securerandom'
require_relative '../lib/commands/ls_command'
require_relative '../lib/commands/cd_command'
require_relative '../lib/commands/cat_command'
require_relative '../lib/commands/touch_command'
require_relative '../lib/commands/rm_command'
require_relative '../lib/commands/mv_command'
require_relative '../lib/color_text'

class FileCommandTest < Test::Unit::TestCase
  # This must be a class variable for delete hook to work properly

  TEST_ITER = 10
  EMPTY_DIR = %w(. ..)

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

  # Asserts that the test directory is the same as the sandbox, including file contents
  def assert_pristine
    out = `#{@sandbox_dir}/pristine.sh #{@sandbox_dir} #{@test_dir}`
    assert_true(out.empty?, "Expected test directory unchanged")
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
            assert_false(printed_files.any? { |f| f.start_with?('.') }, "ls: Prints hidden files by default")
          end
        else
          # We have printed something to stderr
          assert_false($stderr.string.empty?, "ls: Invalid directory should print message to stderr")
        end
        assert_pristine
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
        assert_pristine
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
        assert_pristine
      end
    end
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

  def test_rm
    cmds =
        Dir.entries(@sandbox_dir).map! { |f| "rm #{@test_dir}/#{f}" } +
        ["rm #{@test_dir}/subdir -r"]

    cmds.each do |cmd|
      tokens = cmd.strip.split(' ')

      # Preconditions
      begin
        assert_equal('rm', tokens[0])
      end

      v_dir = valid_dir(tokens[1])
      v_file = valid_file(tokens[1])

      $stderr.reopen
      RmCommand.new(tokens).execute

      # Postconditions
      begin
        if v_dir and (tokens.include?('-r') or tokens.include?('--recursive'))
          assert_false(Dir.exists?(tokens[1]), 'rm: Did not delete directory')
        elsif v_dir
          assert_true(Dir.exists?(tokens[1]), 'rm: Should not delete directories without -r flag')
          assert_false($stderr.string.empty?, "rm: Should print warning that deleting directories requires -r flag")
        elsif v_file
          assert_false(File.exists?(tokens[1]), 'rm: Did not delete file')
        else
          assert_false($stderr.string.empty?, "rm: Invalid file path should print to stderr")
        end
      end
    end

    # We deleted all files in the test directory
    assert_equal(EMPTY_DIR, Dir.entries(@test_dir).sort!)
    create_sandbox # reset
  end

  def test_mv
    cmds = [
        'mv RandomText.txt RandomText1.txt', # rename file
        'mv RandomText1.txt RandomText.txt', # reverse
        'mv invalid.txt invalid1.txt',       # invalid rename file
        'mv subdir/hello.txt hello.txt',     # move file
        'mv hello.txt subdir/hello.txt',     # reverse
        'mv subdir subdir1',                 # rename directory
        'mv subdir1 subdir'                  # reverse
    ]

    cmds.each do |cmd|
      tokens = cmd.strip.split(' ')

      # Preconditions
      begin
        assert_equal('mv', tokens[0])
      end

      v_dir = valid_dir(tokens[1])
      v_file = valid_file(tokens[1])

      $stderr.reopen
      MvCommand.new(tokens).execute

      # Postconditions
      begin
        if v_dir
          assert_false(Dir.exists?(tokens[1]), 'mv: Did not move src directory')
          assert_true(Dir.exists?(tokens[2]), 'mv: Did not move directory to dst')
        elsif v_file
          assert_false(File.exists?(tokens[1]), 'mv: Did not move src file')
          assert_true(File.exists?(tokens[2]), 'mv: Did not move file to dst')
        else
          assert_false($stderr.string.empty?, "mv: Invalid file path should print to stderr")
        end
      end
    end

    # Only works if test commands bring folder state back to original
    assert_pristine
  end
end
