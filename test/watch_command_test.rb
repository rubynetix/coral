require 'test/unit'
require 'securerandom'
require_relative '../lib/commands/watch_create'
require_relative '../lib/commands/watch_alter'
require_relative '../lib/commands/watch_delete'

class FileCommandTest < Test::Unit::TestCase
  # This must be a class variable for delete hook to work properly

  TEST_ITER = 10
  EMPTY_DIR = %w[. ..].freeze

  def initialize(*args)
    super(*args)

    @sandbox_dir = File.expand_path('file_sandbox', __dir__)

    test_dir = File.expand_path("../test_dir_#{SecureRandom.hex(6)}", __FILE__)
    @test_dir = test_dir

    create_sandbox
    ObjectSpace.define_finalizer(self, proc { |_id| self.class.delete(test_dir) })
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
    path.nil? ? true : Dir.exist?(File.expand_path(path))
  end

  def valid_file(path)
    path.nil? ? true : File.exist?(File.expand_path(path))
  end

  # Asserts that the test directory is the same as the sandbox, including file contents
  def assert_pristine
    out = `#{@sandbox_dir}/pristine.sh #{@sandbox_dir} #{@test_dir}`
    assert_true(out.empty?, 'Expected test directory unchanged')
  end

  ###### TESTING ######

  def test_watch_create
    # TODO
  end

  def test_watch_alter
    # TODO
  end

  def test_watch_delete
    # TODO
  end
end
