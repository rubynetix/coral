require_relative 'base_command'
require_relative 'delay_command'

class WatchCommand
  include BaseCommand

  USAGE = ''.freeze

  def initialize(input)
    @opts = parse_args(input)
    @opts.options.banner = USAGE
    @files = !@opts.arguments.empty? ? @opts.arguments : nil
  end

  def nil_or_help?
    if @opts.help? || @files.nil?
      puts @opts.to_s(prefix: '  ')
      return true
    end
    false
  end

  def parse_args(input)
    opts = Slop.parse do |o|
      o.string '-a', '--action', 'action tiggered on detection', required: true
      o.integer '-d', '--duration', 'action time delay in flicks', default: 0
      o.on '-h', '--help' do
        puts USAGE
        exit
      end
    end

    opts.arguments.shift
    opts
  end

  def execute_change_action
    # TODO: what actions? integrate Timer
  end
end
