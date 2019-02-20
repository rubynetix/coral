require 'slop'
require 'shell'
require_relative 'base_command'

class CatCommand
  include BaseCommand

  USAGE = <<~EOS
    Usage: cat [filenames]
      Concatenates files to standard output.

      [options]
  EOS

  def initialize(input)
    args = split_args input
    @opts = Slop.parse args do |o|
      o.bool '-h', '--help'
    end

    @opts.options.banner = USAGE
    @opts.arguments.shift
    @files = @opts.arguments.length > 0 ? @opts.arguments : nil
  end

  def execute
    if @opts.help? || @files.nil?
      puts @opts.to_s(prefix: "  ")
      return
    end

    @files.each do |f|
      if File.directory?(f)
        puts "cat: " + f + ": Is a directory"
      elsif File.file?(f)
        puts Shell.new.cat(f)
      else
        puts "cat: " + f + ": No such file or directory"
      end
    end
  end

end