require_relative 'base_command'
require_relative '../timer/timer'

class WatchCommand
  include Timer
  include BaseCommand

  USAGE = ''.freeze

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
    @files = !@opts.arguments.empty? ? @opts.arguments : nil
  end

  def execute
    if @opts.help? || @dir.nil?
      puts @opts.to_s(prefix: '  ')
      return
    end
  end

  def execute_change_action(action, duration)
    # TODO: what actions? integrate Timer
  end
end
