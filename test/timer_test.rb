require 'test/unit'
require_relative '../lib/timer/timer'

class TimerTest < Test::Unit::TestCase
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
        assert_true(Timer.valid_input?(delay, msg), "Timer input must be an integer delay and string message.")
      end

      $stdout.reopen
      Timer.delay(delay, msg)
      sleep(5)

      # Postconditions
      begin
        # assert_equal(msg, $stdout.string, "Timer should print #{msg} after delay.")
      end
    end
  end
end
