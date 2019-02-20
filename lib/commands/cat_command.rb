require 'slop'
require 'fileutils'
require_relative 'base_command'

class CatCommand
  include BaseCommand

  USAGE = <<~EOS
    Usage: cat [file]
      Print [file] to the standard output

    [options]
  EOS

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
    @file = @opts.arguments.length > 0 ? @opts.arguments[0] : nil
  end

  def execute
    if @opts.help? || @file.nil?
      puts @opts.to_s(prefix: "  ")
      return
    end

    begin
      File.foreach(@file).with_index do |line, line_num|
        puts "#{line}"
      end
    rescue SystemCallError => e
      $stderr.print "#{e.message}\n"
    end

  end
end