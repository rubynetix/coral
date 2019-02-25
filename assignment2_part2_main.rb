# Group No. 6 Members:
#   - Fraser Bulbuc
#   - James Hryniw
#   - Jordan Lane
#   - Ryan Furrer
#   - Tim Tran
#

require_relative 'lib/commands/delay_command'

if ARGV.nil? || ARGV.length < 2
  puts DelayCommand::USAGE
  exit
end
DelayCommand.new(['delay'] + ARGV).execute
