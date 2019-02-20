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

    args = split_args input
    @opts = Slop.parse args do |o|
      o.bool '-r', '--recursive', "Remove directories and their contents."
      o.bool '-v', '--verbose', "Display verbose print messages"
      o.bool '-h', '--help'
    end

    @opts.options.banner = USAGE
    @opts.arguments.shift
    @src, @dst = @opts.arguments
  end

  def execute
    if @opts.help? || @src.nil? || @dst.nil?
      puts @opts.to_s(prefix: "  ")
      return
    end

    begin
      if @opts.recursive?
        FileUtils.cp_r(@src, @dst, verbose: @opts.verbose?)
      else
        FileUtils.cp(@src, @dst, verbose: @opts.verbose?)
      end
    rescue SystemCallError => e
      $stderr.print "#{e.message}\n"
    end

  end
end