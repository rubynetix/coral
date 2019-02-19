require 'slop'
require_relative 'base_command'

class MkdirCommand
  include BaseCommand

  ERR_DIR_EXISTS = "mkdir : cannot create directory %s, file already exists.\n"
  USAGE = <<~EOS
    Usage: mkdir [options] [directory]
      Creates the [directory] if it does not already exist.

    [options]
  EOS

  def initialize(input)
    args = split_args input
    @opts = Slop.parse args do |o|
      o.bool '-h', '--help'
    end

    @opts.options.banner = USAGE
    @opts.arguments.shift
    @dir = @opts.arguments.length > 0 ? @opts.arguments[0] : nil
  end

  def execute
    if @opts.help? || @dir.nil?
      puts @opts.to_s(prefix: "  ")
      return
    end

    if File.exist?(@dir)
      puts ERR_DIR_EXISTS % @dir
      return
    end

    Dir.mkdir(@dir)
  end
end