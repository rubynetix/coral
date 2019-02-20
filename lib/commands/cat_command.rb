require 'slop'
require 'fileutils'
require_relative 'base_command'

class CatCommand
  include BaseCommand

  @restricted_file_chars = ["/",":","\"","'"]
  USAGE = <<~EOS
    Usage: cat [file1] [file2]... [> output file]
      Concatenate file(s) to the standard output or the [> output file]

    [options]
  EOS

  def initialize(input)
    @original_stdout = $stdout
    @read_files = Array.new

    args = split_args input
    @opts = Slop.parse args do |o|
      o.bool '-n', '--number', "Number all output lines"
      o.bool '-E', '--ends', "Display $ at end of each line"
      o.bool '-h', '--help'
    end

    @opts.options.banner = USAGE
    @opts.arguments.shift

    while @opts.arguments.length > 0
      if @opts.arguments[0] == ">"
        if @opts.arguments.length == 1
          raise IOError, "Syntax Error: Unexpected output: ''"
        end
        $stdout.reopen(@opts.arguments[1], "w")
        @opts.arguments.shift(2)
      else
        @read_files.push(@opts.arguments[0])
        @opts.arguments.shift
      end
    end
  end

  def execute
    if @opts.help? || !@read_files.any?
      puts @opts.to_s(prefix: "  ")
      return
    end

    line_num = 1
    line_end_char = "$"
    @read_files.each do |file|
      begin
        File.foreach(file).with_index do |line|
          line_start = @opts.number? ? "#{line_num}" + " " : nil
          line_end = @opts.ends? ? line_end_char : nil

          puts "#{line_start}#{line.chop!}#{line_end}"
          line_num += 1
        end
      rescue SystemCallError => e
        raise e
      end
    end

    $stdout = @original_stdout

  end
end