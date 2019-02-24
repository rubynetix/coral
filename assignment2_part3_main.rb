# Group No. 6 Members:
#   - Fraser Bulbuc
#   - James Hryniw
#   - Jordan Lane
#   - Ryan Furrer
#   - Tim Tran
#

require_relative 'lib/file_monitor'
require_relative 'lib/readers/stdin_reader'
require_relative 'lib/readers/list_reader'

puts
# c = ["ls -a", "mkdir -h", "mkdir ff", "ls"]
# shell = Cmd.new(ListReader.new(c))
shell = FileMonitor.new(StdinReader.new)
shell.cmd_loop
