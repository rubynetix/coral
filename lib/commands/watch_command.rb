require_relative 'base_command'

class WatchCommand
  include BaseCommand

  USAGE = ''.freeze

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
    @files = !@opts.arguments.empty? ? @opts.arguments : nil
  end
end
