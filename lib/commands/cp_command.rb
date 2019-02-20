require 'slop'
require 'fileutils'
require_relative 'base_command'

class CpCommand
  include BaseCommand

  USAGE = <<~EOS
    Usage: cp [source] [dest]
      Copy file from [source] to [dest]

    [options]
  EOS

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
    @src, @dst = @opts.arguments
  end

  def execute
    if @opts.help? || @src.nil? || @dst.nil?
      puts @opts.to_s(prefix: "  ")
      return
    end

    FileUtils.cp(@src, @dst)
  end
end