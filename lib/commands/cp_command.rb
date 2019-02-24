require 'slop'
require 'fileutils'
require_relative 'base_command'

class CpCommand
  include BaseCommand

  USAGE = <<~EOS.freeze
    Usage: cp [source] [dest]
      Copy file from [source] to [dest]

    [options]
  EOS

  def initialize(args)
    @opts = Slop.parse args do |o|
      o.bool '-r', '--recursive', 'Remove directories and their contents.'
      o.bool '-v', '--verbose', 'Display verbose print messages'
      o.bool '-h', '--help'
    end

    @opts.options.banner = USAGE
    @opts.arguments.shift
    @src, @dst = @opts.arguments
  end

  def execute
    if @opts.help? || @src.nil? || @dst.nil?
      puts @opts.to_s(prefix: '  ')
      return
    end

    begin
      if @opts.recursive?
        FileUtils.cp_r(@src, @dst, verbose: @opts.verbose?)
      else
        unless File.directory?(@src)
          FileUtils.cp(@src, @dst, verbose: @opts.verbose?)
        else
          raise StandardError, "cp: ommiting directory #{@src}. Cannot perform non-recursive copy on directory"
        end
      end
    rescue SystemCallError => e
      $stderr.print "#{e.message}\n"
    rescue StandardError => e
      $stderr.print "#{e.message}\n"
    end
  end
end
