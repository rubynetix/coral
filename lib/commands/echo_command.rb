require 'slop'
require 'shell'
require_relative 'base_command'

class EchoCommand
  include BaseCommand

  USAGE = <<~EOS.freeze
    Usage: echo [TEXT]...
      Displays a line of text

      [options]
  EOS

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
    @text = !@opts.arguments.empty? ? @opts.arguments : nil
  end

  def execute
    if @opts.help? || @text.nil?
      puts @opts.to_s(prefix: '  ')
      return
    end

    puts Shell.new.echo(@text.join(" "))
  end
end
