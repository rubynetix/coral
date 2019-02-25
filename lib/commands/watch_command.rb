require_relative 'base_command'
require_relative 'delay_command'

class WatchCommand
  include BaseCommand

  attr_reader(:opts)

  def initialize(input)
    @opts = parse_args(input)
    @files = !@opts.arguments.empty? ? @opts.arguments : nil
  end

  def nil_or_help?
    if @opts.help? || @files.nil?
      puts @opts.to_s(prefix: '  ')
      return true
    end
    false
  end

  def parse_args(args)
    opts = Slop.parse args do |o|
      o.string '-a', '--action', 'action triggered on detection'
      o.int '-d', '--duration', 'action time delay in flicks', default: 0
      o.bool '-h', '--help'
    end

    opts.arguments.shift
    opts
  end

  def execute_change_action
    # TODO: what actions? integrate Timer
  end
end
