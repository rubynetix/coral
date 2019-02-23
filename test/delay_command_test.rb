require 'test/unit'
require_relative '../lib/commands/delay_command'

class DelayCommandTest < Test::Unit::TestCase
  TEST_ITER = 1

  def setup
    # Capture stdout
    $stdout = StringIO.new
  end

  def rand_msg(len = rand(1..100))
    # Taken from https://stackoverflow.com/a/88341
    (0...len).map { (65 + rand(26)).chr }.join
  end

  def test_smoke_test
    # TODO: Replace with meaningful tests
    msg = rand_msg
    delay = rand(1...10)

    TEST_ITER.times do
      # Preconditions
      begin
      end

      $stdout.reopen
      DelayCommand.new([msg.to_s, delay.to_s]).execute
      sleep(3)

      # Postconditions
      begin
        # assert_equal(msg, $stdout.string, "Timer should print #{msg} after delay.")
      end
    end
  end
end
