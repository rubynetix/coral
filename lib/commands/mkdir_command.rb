require 'slop'
require_relative 'base_command'

class MkdirCommand
  include BaseCommand

  ERR_DIR_EXISTS = "mkdir : cannot create directory %s, file already exists.\n".freeze
  USAGE = <<~EOS.freeze
    Usage: mkdir [options] [directory]
      Creates the [directory] if it does not already exist.

    [options]
  EOS

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
    @dir = @opts.arguments[0]
  end

  def execute
    if @opts.help? || @dir.nil?
      puts @opts.to_s(prefix: '  ')
      return
    end

    if File.exist?(@dir)
      puts ERR_DIR_EXISTS % @dir
      return
    end

    Dir.mkdir(@dir)
  end
end
