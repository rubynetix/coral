require 'test/unit'
require 'securerandom'
require_relative '../lib/commands/ls_command'
require_relative '../lib/color_text'

class FileCommandTest < Test::Unit::TestCase
  # This must be a class variable for delete hook to work properly
  @@test_dir = nil

  TEST_ITER = 10

  def initialize(*args)
    super(*args)

    @sandbox_dir = File.expand_path("../file_sandbox", __FILE__)

    @@test_dir = File.expand_path("../test_dir_#{SecureRandom.hex(6)}", __FILE__)
    @@test_dir.freeze

    create_sandbox
    ObjectSpace.define_finalizer(self, FileCommandTest.method(:delete))
  end

  def setup
    # Setup reading from stdout and stderr
    $stdout = StringIO.new
    $stderr = StringIO.new

    # Use @test_dir in testing in case we want to change the
    # class cleanup implementation
    @test_dir = @@test_dir

    Dir.chdir(@test_dir)
  end

  def create_sandbox
    %x(cp -rf #{@sandbox_dir} #{@@test_dir})
  end

  def self.delete(id)
    # Delete the test directory after the tests are over
    %x(rm -rf #{@@test_dir})
  end

  def str_select(s)
    new_str = ""
    s.each_char do |c|
      if yield(c)
        new_str += c
      end
    end
    new_str
  end

  ###### TESTING ######

  def test_ls
    files = Dir.entries(@sandbox_dir).sort!
    no_hidden_files = files.select {|f|  not f.start_with?('.') }
    sub_files = Dir.entries("#{@sandbox_dir}/subdir").select {|f|  not f.start_with?('.') }.sort!

    cmds = [
      'ls',
      'ls . -a',
      "ls #{@test_dir} -a",
      "ls #{@test_dir}/subdir",
      "ls invalid_dir"
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
      LsCommand.new(cmd).execute

      # Postconditions
      begin
        if e_files.size > 0
          printed_files = $stdout.string.split("\n")
                              .select {|f| f != "" }
                              .map { |f| ColorText.rm_color(f) }

          assert_true(printed_files.size > 0)
          assert_equal(e_files, printed_files.sort)
        else
          # We have printed something to stderr
          assert_true($stderr.string.size > 0)
        end
      end
    end
  end
end
