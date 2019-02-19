require 'slop'
require 'fileutils'
require_relative 'base_command'

class RmCommand
  include BaseCommand

  USAGE = <<~EOS
    Usage: rm [options] [file/directory]
      Remove the [file/directory].

    [options]
  EOS

  def initialize(input)
    args = split_args input
    @opts = Slop.parse args do |o|
      o.bool '-r', '--recursive', "Remove directories and their contents."
      o.bool '-f', '--force', "Ignore nonexistent files and arguments."
      o.bool '-h', '--help'
    end

    @opts.options.banner = USAGE
    @opts.arguments.shift
    @file = @opts.arguments.length > 0 ? @opts.arguments[0] : nil
  end

  def execute
    if @opts.help? || @file.nil?
      puts @opts.to_s(prefix: "  ")
      return
    end

    begin
      if @opts.recursive?
        FileUtils.rm_r(@file, force: @opts.force?)
      else
        FileUtils.rm(@file, force: @opts.force?)
      end
    rescue SystemCallError => e
      $stderr.print "#{e.message}\n"
    end
  end
end
