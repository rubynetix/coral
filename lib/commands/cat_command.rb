require 'slop'
require 'shell'
require_relative 'base_command'

class CatCommand
  include BaseCommand

  USAGE = <<~EOS.freeze
    Usage: cat [FILES]...
      Concatenates FILES to standard output.

      [options]
  EOS

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
    @files = !@opts.arguments.empty? ? @opts.arguments : nil
  end

  def execute
    if @opts.help? || @files.nil?
      puts @opts.to_s(prefix: '  ')
      return
    end

    @files.each do |f|
      if File.directory?(f)
        puts 'cat: ' + f + ': Is a directory'
      elsif File.file?(f)
        puts Shell.new.cat(f)
      else
        puts 'cat: ' + f + ': No such file or directory'
      end
    end
  end
end
