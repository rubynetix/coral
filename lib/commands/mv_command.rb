require 'slop'
require 'fileutils'
require_relative 'base_command'

class MvCommand
  include BaseCommand

  USAGE = <<~EOS.freeze
    Usage: mv [source] [dest]
      Rename [source] to [dest], or move [source] to [dest].

    [options]
  EOS

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
    @src, @dst = @opts.arguments
  end

  def execute
    if @opts.help? || @src.nil? || @dst.nil?
      puts @opts.to_s(prefix: '  ')
      return
    end

    FileUtils.mv(@src, @dst)
  end
end
