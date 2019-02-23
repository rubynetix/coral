# Group No. 6 Members:
#   - Fraser Bulbuc
#   - James Hryniw
#   - Jordan Lane
#   - Ryan Furrer
#   - Tim Tran
#

require_relative 'lib/timer/timer'

if ARGV.length != 2
  puts 'Usage: ruby assignment2_part2_main.rb [time-units] "[expiration-msg]"'
  exit 0
end

Timer.delay(ARGV[0].to_i, ARGV[1])
