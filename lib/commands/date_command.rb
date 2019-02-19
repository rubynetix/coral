require 'time'
require_relative 'base_command'

class DateCommand
  include BaseCommand

  def initialize

  end

  def execute
    puts Time.now.strftime('%a %b %d %T %Z %Y')
  end
end