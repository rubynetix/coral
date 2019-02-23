require 'test/unit'
require 'time'
require 'timecop'
require_relative '../lib/commands/date_command'

class TimeCommandTest < Test::Unit::TestCase

  RX_WEEKDAY = '(Mon|Tue|Wed|Thu|Fri|Sat|Sun)'
  RX_MONTH = '(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)'
  RX_TIME = '(\\d+):(\\d+):(\\d+)'
  RX_DATE = "#{RX_WEEKDAY}\\s(\\w+)\\s(\\d+)\\s#{RX_TIME}\\s[A-Z]+\\s(\\d+)"
  DATE_REGEX = Regexp.new(RX_DATE)

  TEST_ITER = 10

  def setup
    # Setup reading from stdout and stderr
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  def assert_in_range(val, min, max)
    assert_true(val >= min)
    assert_true(val <= max)
  end

  def test_date
    t1 = Time.parse("1900-1-1 00:00:00")
    t2 = Time.parse("2099-12-31 23:59:59")

    TEST_ITER.times do
      # Postconditions
      begin
      end

      $stdout.reopen
      Timecop.freeze(rand(t1..t2)) do
        DateCommand.new(['date']).execute
      end

      # Postconditions
      begin
        date_match = DATE_REGEX.match($stdout.string)
        assert_not_nil(date_match)

        _, _, day, h, m, s, year = date_match.captures
        assert_in_range(day.to_i, 1, 31)
        assert_in_range(h.to_i, 0, 23)
        assert_in_range(m.to_i, 0, 59)
        assert_in_range(s.to_i, 0, 59)
        assert_in_range(year.to_i, 1900, 2099)
      end
    end
  end
end