require_relative 'base_command'
require_relative 'delay_command'
require_relative '../time_util'

class WatchCommand
  include BaseCommand

  attr_reader(:opts)

  USAGE = ''.freeze

  def initialize(input)
    @opts = parse_args(input)
    @opts.options.banner = self.class::USAGE
    @files = !@opts.arguments.empty? ? @opts.arguments : nil
  end

  def nil_or_help?
    @opts.help? || @files.nil?
  end

  def parse_args(args)
    opts = Slop.parse args do |o|
      o.string '-a', '--action', 'action triggered on detection', required: true
      o.int '-d', '--duration', 'action time delay in flicks', default: 0
      o.bool '-v', '--verbose', 'display file that triggered the action', default: true
      o.on '-h', '--help' do
        puts self.class::USAGE
      end
    end

    opts.arguments.shift
    opts
  end

  def execute_action(file)
    action = @opts[:action]
    duration = @opts[:duration]
    verbose = @opts.verbose?

    # We need to execute this in a subthread in order to keep checking other files
    Thread.new do
      TimeUtil::delay_flicks(duration)
      puts "WATCH TRIGGERED: #{File.basename(file)}" if verbose

      sub_shell = Cmd.new(ListReader.new([action]), nil)
      sub_shell.cmd_loop
    end
  end
end
