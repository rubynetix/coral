require 'test/unit'
require_relative '../lib/commands/delay_command'

class DelayCommandTest < Test::Unit::TestCase

  def setup
    dir = File.expand_path('../assignment2_part2_main.rb', __dir__)
    @driver = "ruby #{dir}"
    puts @driver
  end

  def rand_msg(len = rand(1..25))
    # Taken from https://stackoverflow.com/a/88341
    (0...len).map { (65 + rand(26)).chr }.join
  end

  def time(&block)
    start = Time.now
    output = yield block
    [output, Time.now - start]
  end

  def test_timer
    msg = rand_msg
    args = [
        # All delays are equivalent to 1 second
        ['', 1000000000],
        ['-b', 1000000000],
        ['-u s', 1],
        ['-b -u s', 1],
        ['-u ms', 1000],
        ['-b -u ms', 1000],
        ['-u us', 1000000],
        ['-b -u us', 1000000],
        ['-u ns', 1000000000],
        ['-b -u ns', 1000000000],
    ]

    args.each do |flags, delay|
      # Preconditions
      begin
      end

      output, duration = time {`#{@driver} #{flags} #{delay} #{msg}`.chomp}

      # Postconditions
      begin
        assert_true(duration > 1, "Subprocess should task at least 1 second.")
        assert_equal(msg, output, "Timer should print '#{msg}'after delay -- received '#{output}'")
      end
    end
  end
end
