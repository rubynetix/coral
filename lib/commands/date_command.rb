require 'time'
require_relative 'base_command'

class DateCommand
  include BaseCommand

  def initialize

  end

  def execute
    puts Time.new
  end
end