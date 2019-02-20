require 'slop'
require 'fileutils'
require_relative 'base_command'

class TouchCommand
  include BaseCommand

  USAGE = <<~EOS
    Usage: touch [file]
      Update the access and modification times of [file]. 

      If [file] does not exist, it will be created.

    [options]
  EOS

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
    @file = @opts.arguments[0]
  end

  def execute
    if @opts.help? || @file.nil?
      puts @opts.to_s(prefix: "  ")
      return
    end

    FileUtils.touch(@file)
  end
end