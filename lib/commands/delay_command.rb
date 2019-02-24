require 'slop'
require_relative 'base_command'
require_relative '../timer/ctimer'

class DelayCommand
  include BaseCommand

  USAGE = <<~EOS.freeze
    Usage: delay [options] [time] "[message]"
      Prints [message] after a non-blocking delay of [time] nanoseconds.

    [options]
  EOS

  def initialize(args)
    @opts = Slop.parse args do |o|
      o.string '-u', '--units', 'Specify alternate SI units. Valid options are s, ms, us, ns.'
      o.bool '-h', '--help'
    end

    @opts.options.banner = USAGE
    @opts.arguments.shift
    @ns, @msg = parse_args(@opts.arguments[0], @opts.arguments[1])
  end

  def execute
    if @opts.help?
      puts @opts.to_s(prefix: '  ')
      return
    end

    child = Process.fork do
      Ctimer::delay(@ns)
      puts @msg
      exit
    end

    Process.detach(child)
  end

  private

  def parse_args(time, msg)
    begin
      ns = Integer(time)
    rescue ArgumentError => e
      $stderr.print "#{e.message}\n"
      exit 1
    end

    [to_nanos(ns), msg]
  end

  def to_nanos(time)
    case @opts[:units]
    when "s"
      time * 1_000_000_000
    when "ms"
      time * 1_000_000
    when "us"
      time * 1_000
    when "ns"
      time
    else
      time
    end
  end
end
